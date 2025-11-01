#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
采集某进程所有线程 /proc/<pid>/task/<tid>/io，导出 CSV（按秒速率或累计值）
需要内核启用 TASK_IO_ACCOUNTING（常见发行版默认启用）。
"""

import argparse, csv, os, time, math
from datetime import datetime
from typing import Dict, Tuple, Optional

IO_FIELDS_ORDER = [
    # /proc/<pid>/task/<tid>/io 的典型字段名（不同内核可能增减）
    "rchar",                 # 读的字符数（含缓存、用户空间层）
    "wchar",                 # 写的字符数
    "syscr",                 # read(2) 次数
    "syscw",                 # write(2) 次数
    "read_bytes",            # 触发的实际读到块层的字节数
    "write_bytes",           # 触发的实际写到块层的字节数
    "cancelled_write_bytes", # 被取消的写字节（如 direct-IO 取消）
]

def read_thread_comm(tid: int) -> str:
    try:
        with open(f"/proc/{tid}/comm", "r", encoding="utf-8", errors="replace") as f:
            return f.read().strip()
    except Exception:
        return ""

def read_task_io(pid: int, tid: int) -> Optional[Dict[str, int]]:
    path = f"/proc/{pid}/task/{tid}/io"
    try:
        d = {}
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            for line in f:
                line = line.strip()
                if not line or ":" not in line:
                    continue
                k, v = line.split(":", 1)
                k = k.strip()
                v = v.strip()
                if v.endswith("bytes"):  # 某些发行版会带单位
                    v = v[:-5].strip()
                try:
                    d[k] = int(v)
                except Exception:
                    pass
        return d if d else None
    except FileNotFoundError:
        return None
    except PermissionError:
        # 普通用户读取别的用户的线程可能会权限不足
        return None

def list_tids(pid: int):
    try:
        return [int(x) for x in os.listdir(f"/proc/{pid}/task") if x.isdigit()]
    except Exception:
        return []

def now_ts():
    # 使用 wall-clock 时间方便和外部系统对齐；速率计算用 perf_counter 保证精度
    return datetime.now().isoformat(timespec="seconds")

def fmt_rate(v_per_s: Optional[float], unit_div: float) -> str:
    if v_per_s is None:
        return ""
    return f"{v_per_s / unit_div:.3f}"

def main():
    ap = argparse.ArgumentParser(description="Export per-thread /proc io to CSV.")
    ap.add_argument("-p", "--pid", required=True, type=int, help="Target PID")
    ap.add_argument("-i", "--interval", type=float, default=1.0, help="Sampling interval seconds (default: 1.0)")
    ap.add_argument("-d", "--duration", type=float, default=0.0, help="Total duration seconds (0 = run forever)")
    ap.add_argument("-o", "--output", default="-", help="CSV output file (default: stdout)")
    ap.add_argument("--mode", choices=["rate", "cumulative"], default="rate",
                    help="Output 'rate' (per-second) or 'cumulative' raw counters (default: rate)")
    ap.add_argument("--unit", choices=["bytes", "KB", "MB"], default="bytes",
                    help="Unit for *_bytes columns when mode=rate (default: bytes)")
    ap.add_argument("--include-syscalls", action="store_true",
                    help="When mode=rate, also output syscr/s, syscw/s (默认只输出字节速率 + rchar/wchar)")
    args = ap.parse_args()

    unit_div = {"bytes": 1.0, "KB": 1024.0, "MB": 1024.0 * 1024.0}[args.unit]

    # CSV 列：时间戳、PID、TID、线程名、之后是字段（按选择速率或累计）
    header = ["timestamp", "pid", "tid", "tname"]
    if args.mode == "rate":
        # 速率列
        header += ["rchar/s", "wchar/s", "read_bytes/s", "write_bytes/s", "cancelled_write_bytes/s"]
        if args.include_syscalls:
            header += ["syscr/s", "syscw/s"]
    else:
        # 累计列（原样抄 io 文件值）
        header += IO_FIELDS_ORDER

    out = (open(args.output, "w", newline="") if args.output != "-" else None)
    writer = csv.writer(out if out else os.fdopen(os.dup(1), "w", newline=""))
    writer.writerow(header)

    prev: Dict[int, Tuple[float, Dict[str, int]]] = {}  # tid -> (t_last, counters)

    t_start = time.perf_counter()
    next_tick = t_start

    try:
        while True:
            # 退出条件
            if args.duration > 0 and (time.perf_counter() - t_start) >= args.duration:
                break

            # 对齐到下一采样点
            now_perf = time.perf_counter()
            if now_perf < next_tick:
                time.sleep(next_tick - now_perf)
            tick_time = time.perf_counter()
            next_tick = tick_time + max(0.001, args.interval)

            ts = now_ts()
            tids = list_tids(args.pid)
            if not tids:
                # 进程可能退出
                break

            # 读取每个线程
            current: Dict[int, Dict[str, int]] = {}
            for tid in tids:
                io = read_task_io(args.pid, tid)
                if io is None:
                    continue
                current[tid] = io

            # 输出
            for tid, cur in current.items():
                tname = read_thread_comm(tid)

                if args.mode == "cumulative":
                    row = [ts, args.pid, tid, tname]
                    for k in IO_FIELDS_ORDER:
                        row.append(cur.get(k, 0))
                    writer.writerow(row)
                    continue

                # mode == rate
                if tid not in prev:
                    # 首次出现无法计算速率，输出空白（也可输出 0，看你需求）
                    continue
                else:
                    t_prev, prev_cnt = prev[tid]
                    dt = max(1e-9, tick_time - t_prev)

                    def rate(field: str) -> Optional[float]:
                        if field not in cur or field not in prev_cnt:
                            return None
                        dv = cur[field] - prev_cnt[field]
                        # 计数器回绕（极罕见）或重置，做个防御
                        if dv < 0:
                            return None
                        return dv / dt

                    rchar_s   = rate("rchar")
                    wchar_s   = rate("wchar")
                    read_s    = rate("read_bytes")
                    write_s   = rate("write_bytes")
                    cwrite_s  = rate("cancelled_write_bytes")
                    syscr_s   = rate("syscr") if args.include_syscalls else None
                    syscw_s   = rate("syscw") if args.include_syscalls else None

                    row = [ts, args.pid, tid, tname]
                    row += [
                        fmt_rate(rchar_s, unit_div),
                        fmt_rate(wchar_s, unit_div),
                        fmt_rate(read_s, unit_div),
                        fmt_rate(write_s, unit_div),
                        fmt_rate(cwrite_s, unit_div),
                    ]
                    if args.include_syscalls:
                        row += [
                            f"{syscr_s:.3f}" if syscr_s is not None else "",
                            f"{syscw_s:.3f}" if syscw_s is not None else "",
                        ]
                    writer.writerow(row)

            # 更新 prev，移除已消失的 TID
            new_prev: Dict[int, Tuple[float, Dict[str, int]]] = {}
            for tid, cur in current.items():
                new_prev[tid] = (tick_time, cur.copy())
            prev = new_prev

            # 立刻刷盘
            try:
                (out or writer).flush()
            except Exception:
                pass

    except KeyboardInterrupt:
        pass
    finally:
        if out:
            out.close()

if __name__ == "__main__":
    main()

