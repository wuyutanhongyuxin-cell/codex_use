# Sub2API 多账号使用教程

## 实现原理

Sub2API 运行在本机 `http://localhost:8080`，它作为一个 API 网关管理多个上游账号。

客户端不直接连接多个账号，而是统一连接 Sub2API：

```text
Base URL: http://localhost:8080/openai/v1
API Key:  Sub2API 管理台生成的 sk-xxxx
```

请求进入 Sub2API 后，Sub2API 根据分组、账号状态、并发、额度和粘性会话规则，从账号池里选择一个可用上游账号转发请求。

## 推荐结构

```text
上游账号 A
上游账号 B
上游账号 C
        |
        v
分组 codex-main
        |
        v
Sub2API API Key
        |
        v
Codex / OpenAI 兼容客户端
```

## 第一次启动

双击桌面文件：

```text
Sub2API傻瓜启动器.hta
```

然后按顺序点击：

```text
启动服务 -> 查看日志 -> 打开管理台
```

第一次启动会下载 Docker 镜像，可能需要几分钟。

## 登录管理台

管理台地址：

```text
http://localhost:8080
```

默认管理员邮箱：

```text
admin@sub2api.local
```

首次管理员密码在日志里查看。

## 添加多个上游账号

进入管理台后：

```text
账号管理 / Accounts
-> 新增账号
-> 选择平台
-> 选择认证方式
-> 填写 API Key / OAuth / 其他凭据
-> 保存
```

每个真实账号添加一次。例如：

```text
codex-account-1
codex-account-2
codex-account-3
```

不要把账号凭据写进本仓库。

## 创建分组

创建一个分组：

```text
codex-main
```

把多个上游账号加入这个分组。

最简单的多账号模式就是：一个分组里放多个账号，让 Sub2API 自动调度。

## 创建客户端 API Key

在管理台创建一个 API Key，并绑定到 `codex-main` 分组。

客户端只需要保存这个 Sub2API API Key，不需要知道背后有多少个上游账号。

## 客户端配置

OpenAI 兼容客户端通常填写：

```text
Base URL: http://localhost:8080/openai/v1
API Key:  sk-your-sub2api-key
```

PowerShell 临时设置：

```powershell
.\scripts\use-sub2api-openai-env.ps1 -ApiKey "sk-your-sub2api-key"
```

## 常见多账号玩法

自动调度：

```text
多个账号 -> 一个分组 -> 一个 API Key
```

按用途隔离：

```text
codex-work   -> 工作账号池
codex-test   -> 测试账号池
codex-backup -> 备用账号池
```

按客户端隔离：

```text
API Key A -> 电脑 A
API Key B -> 电脑 B
API Key C -> 自动化脚本
```

## 停止服务

回到桌面启动器，点击：

```text
停止服务
```

本地数据会保留在 `runtime/sub2api`，该目录已被 `.gitignore` 忽略，不会上传。

## 安全注意

- 不上传 `runtime/`。
- 不上传 `.env`。
- 不上传 Cookie。
- 不上传真实 API Key。
- 不把模型相似度、请求调度结果或账号命中结果当成身份或权限证明。
