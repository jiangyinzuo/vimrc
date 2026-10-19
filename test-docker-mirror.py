#!/usr/bin/env python3
"""Compare public GHCR mirrors without Docker; download at most 8 MiB per host."""

import argparse
import concurrent.futures
import json
import re
import time
import urllib.error
import urllib.parse
import urllib.request

ACCEPT = ", ".join(
    (
        "application/vnd.oci.image.index.v1+json",
        "application/vnd.docker.distribution.manifest.list.v2+json",
        "application/vnd.oci.image.manifest.v1+json",
        "application/vnd.docker.distribution.manifest.v2+json",
    )
)
SAMPLE_BYTES = 8 * 1024 * 1024


def probe(host, args):
    started = time.monotonic()
    headers = {"Accept": ACCEPT}
    base = f"https://{host}/v2/{args.repository}"

    def get(url, extra=None):
        request = urllib.request.Request(url, headers={**headers, **(extra or {})})
        return urllib.request.urlopen(request, timeout=args.timeout)

    try:
        manifest_url = f"{base}/manifests/{args.tag}"
        try:
            response = get(manifest_url)
        except urllib.error.HTTPError as error:
            if error.code != 401:
                raise
            challenge = error.headers.get("WWW-Authenticate", "")
            error.close()
            if not challenge.lower().startswith("bearer "):
                raise ValueError(f"Unsupported authentication: {challenge}")
            auth = dict(re.findall(r'(\w+)="([^"]*)"', challenge))
            realm = auth["realm"]
            if urllib.parse.urlsplit(realm).scheme != "https":
                raise ValueError("Token endpoint must use HTTPS")
            query = urllib.parse.urlencode(
                {
                    "service": auth.get("service", ""),
                    "scope": auth.get("scope", f"repository:{args.repository}:pull"),
                }
            )
            separator = "&" if "?" in realm else "?"
            with urllib.request.urlopen(
                f"{realm}{separator}{query}", timeout=args.timeout
            ) as token_response:
                token = json.load(token_response)
            headers["Authorization"] = "Bearer " + (token.get("token") or token["access_token"])
            response = get(manifest_url)
        with response:
            manifest = json.load(response)
            digest = response.headers.get("Docker-Content-Digest")
        if "manifests" in manifest:
            selected = next(
                item for item in manifest["manifests"]
                if item.get("platform", {}).get("os") == "linux"
                and item.get("platform", {}).get("architecture") == args.architecture
            )
            digest = selected["digest"]
            with get(f"{base}/manifests/{digest}") as response:
                manifest = json.load(response)
        manifest_seconds = time.monotonic() - started
        layer = max(manifest["layers"], key=lambda item: item["size"])
        expected = min(SAMPLE_BYTES, layer["size"])
        downloaded = 0
        download_started = time.monotonic()
        with get(
            f"{base}/blobs/{layer['digest']}",
            {"Range": f"bytes=0-{expected - 1}"},
        ) as response:
            while downloaded < expected:
                if time.monotonic() - download_started > args.timeout:
                    raise TimeoutError("Download exceeded time limit")
                chunk = response.read(min(256 * 1024, expected - downloaded))
                if not chunk:
                    break
                downloaded += len(chunk)
        seconds = time.monotonic() - download_started
        if downloaded != expected:
            raise ValueError(f"Incomplete sample: {downloaded}/{expected} bytes")
        return {
            "host": host,
            "manifest_seconds": round(manifest_seconds, 2),
            "platform_digest": digest,
            "layer_digest": layer["digest"],
            "download_MiB": round(downloaded / 1048576, 2),
            "download_seconds": round(seconds, 2),
            "MiB_per_second": round(downloaded / 1048576 / seconds, 2),
        }
    except Exception as error:
        return {"host": host, "error": f"{type(error).__name__}: {error}"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("hosts", nargs="*", default=["ghcr.io", "ghcr.nju.edu.cn"])
    parser.add_argument("--repository", default="vectorize-io/hindsight")
    parser.add_argument("--tag", default="latest")
    parser.add_argument("--architecture", default="amd64")
    parser.add_argument("--timeout", type=float, default=60, help="Socket/download timeout in seconds")
    args = parser.parse_args()
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    with concurrent.futures.ThreadPoolExecutor(max_workers=min(4, len(args.hosts))) as pool:
        results = list(pool.map(lambda host: probe(host, args), args.hosts))
    print(json.dumps(results, ensure_ascii=False, indent=2), flush=True)
    successful = [result for result in results if "error" not in result]
    signatures = {(result["platform_digest"], result["layer_digest"]) for result in successful}
    if len(signatures) > 1:
        print("WARNING: Digests differ; hosts did not serve the same image/layer.")
        return 1
    return int(len(successful) != len(results))


if __name__ == "__main__":
    raise SystemExit(main())
