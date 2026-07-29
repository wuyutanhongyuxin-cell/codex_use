# Codex 多账号登录方案

## 概述

本指南提供三种可靠的方案来实现 Codex 的多账号登录，优先推荐手动提取 Cookie 的方式，因为它最稳定可靠。

## 方案一：手动提取 Cookie（推荐）

### 1. 准备工作

```bash
# 创建临时目录存放 cookie 文件
mkdir -p ~/.codex/cookies
```

### 2. 手动登录并提取 Cookie

1. 打开 Chrome 浏览器
   ```bash
   chrome --incognito --user-data-dir="C:\temp\codex_auth"
   ```

2. 访问 [https://auth.codex.ai](https://auth.codex.ai)

3. 使用你的账号登录

4. 按 `F12` 打开开发者工具

5. 切到 **Network** 标签页

6. 刷新页面，找到 `https://api.codex.ai/v1/auth/login` 请求

7. 点击该请求，在 **Headers** 选项卡中找到 `Set-Cookie` 字段

8. 复制所有 cookie 值

### 3. 配置 Codex 使用 Cookie

```bash
# 创建 cookie 文件
echo "session=your-cookie-value; path=/; domain=.codex.ai; secure; HttpOnly" > ~/.codex/cookies/codex.cookie

# 设置环境变量
set CODEX_COOKIE_FILE=~/.codex/cookies/codex.cookie
```

### 4. 启动 Codex

```bash
# 使用 cookie 文件启动
codex --cookie-file ~/.codex/cookies/codex.cookie
```

## 方案二：使用 sub2api + Cookie（支持多账号）

### 1. 安装 sub2api

```bash
npm install -g sub2api
```

### 2. 配置文件 config.json

```json
{
  "server": {
    "port": 8080,
    "host": "localhost"
  },
  "accounts": [
    {
      "name": "account1",
      "cookie": "session=your-cookie-1; path=/; domain=.codex.ai; secure; HttpOnly",
      "proxy": true
    },
    {
      "name": "account2",
      "cookie": "session=your-cookie-2; path=/; domain=.codex.ai; secure; HttpOnly",
      "proxy": true
    }
  ],
  "rules": [
    {
      "pattern": "^https://api.codex.ai/v1/",
      "target": "https://api.codex.ai/v1/"
    }
  ]
}
```

### 3. 启动服务

```bash
sub2api start --config config.json
```

### 4. 配置 Codex 使用代理

```bash
# 设置环境变量
set CODEX_PROXY=http://localhost:8080

# 或者在 codex-cli 的配置文件中设置
echo 'proxy = "http://localhost:8080"' >> ~/.codex/config.toml
```

### 5. 切换账号

```bash
# 使用不同账号时切换环境变量
set CODEX_ACCOUNT=account1
codex

# 或者用不同的命令行参数
codex --account account2
```

## 方案三：定期更新 cookie

### 1. 监控 cookie 过期

Cookie 通常在 24-48 小时后过期。当出现以下情况时，需要重新提取 cookie：

- 登录失败
- 提示需要重新认证
- 请求返回 401 错误

### 2. 自动化更新脚本

```bash
# create_cookie_script.bat
@echo off
:: 启动 Chrome 并自动登录
start chrome --incognito --user-data-dir="C:\temp\codex_auth" https://auth.codex.ai

:: 等待用户登录
timeout /t 60

:: 提取 cookie（需要手动复制）
echo 请在 Chrome 开发者工具中提取 cookie 并保存到 ~/.codex/cookies/codex.cookie
pause
```

### 3. 设置提醒

建议每 24 小时检查一次 cookie 是否有效，避免因会话过期导致的工作中断。

## 注意事项

1. **安全第一**：不要将 cookie 分享给他人，也不要存储在不安全的地方
2. **定期更新**：cookie 会过期，需要定期重新提取
3. **备份重要数据**：在切换账号前，确保重要工作已保存
4. **测试连接**：每次切换账号后，先测试连接是否正常
5. **遵守使用条款**：确保你的使用符合 Codex 的服务条款

> ⚠️ 警告：自动化登录可能违反服务条款，请谨慎使用。