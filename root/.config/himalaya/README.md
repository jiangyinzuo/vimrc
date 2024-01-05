# Himalaya

## 解析邮件中的icalendar格式

安装依赖
```bash
pip install icalendar
```

```bash
himalaya read 1657253743 | ical2text
```

See: root/scripts/wsl/ical2text

## 设置密码

修改密码读取方式时，不要直接编辑`config.toml`，要先备份原来的`config.toml`，
删除`config.toml`后，再按照初始化配置流程，根据提示一步步输入。

### pass 命令行密码管理工具

安装
```bash
sudo apt install pass
```

在使用 `pass`, 一款基于 Unix shell 的密码管理器时，您需要生成一个 GPG (GNU Privacy Guard) 密钥来加密密码。这是一个涉及公钥/私钥加密的过程。以下是生成 GPG 密钥的步骤：

1. **安装 GPG**：首先确保您的系统上安装了 GPG。在大多数 Linux 发行版中，它可以通过包管理器安装。例如，在 Ubuntu 或 Debian 上，您可以使用以下命令安装：
   ```bash
   sudo apt-get install gnupg
   ```

2. **生成 GPG 密钥**：运行 GPG 密钥生成命令：
   ```bash
   gpg --full-gen-key
   ```
   这将启动一个交互式命令行过程，引导您完成一系列步骤来设置您的密钥。

3. **选择密钥类型**：您通常可以选择默认的密钥类型（RSA 和 RSA），除非有特定的需求。

4. **密钥长度**：选择一个适当的密钥长度。2048 位通常是安全的，但 4096 位提供了更高的安全性。

5. **设置密钥有效期限**：您可以为密钥设置一个有效期限，或选择让密钥永久有效。

6. **确认信息并设置密码**：输入您的姓名、电子邮件地址等信息，然后为您的私钥设置一个强密码。这个密码将在您使用 GPG 密钥时被要求输入。

7. **生成密钥**：完成这些步骤后，GPG 将生成密钥对。这可能需要一些时间，取决于所选的密钥长度和系统的处理能力。

8. **确认密钥生成**：一旦密钥生成完成，您可以通过以下命令列出 GPG 密钥来确认：
   ```bash
   gpg --list-secret-keys
   ```

9. **将 GPG 密钥与 `pass` 配置**：一旦密钥生成，您需要配置 `pass` 以使用该密钥。首先，获取您的 GPG 密钥 ID：
   ```bash
   gpg --list-secret-keys --keyid-format LONG
   ```

   输出形如
   ```
   gpg: checking the trustdb
   gpg: marginals needed: 3  completes needed: 1  trust model: pgp
   gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
   /root/.gnupg/pubring.kbx
   ------------------------
   sec   rsa3072/<GPG密钥ID> 2024-01-05 [SC]
         <xxxxxx>
   uid                 [ultimate] jiangyinzuo (gpgkey) <jiangyinzuo@foxmail.com>
   ssb   rsa3072/<xxx> 2024-01-05 [E]
   ```

   然后，初始化 `pass`，使用您的 GPG 密钥 ID：
   ```bash
   pass init "您的GPG密钥ID"
   ```

