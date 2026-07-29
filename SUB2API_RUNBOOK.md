# Sub2API 本地运行说明

本目录已克隆主仓库：

```powershell
sub2api
```

准备运行配置：

```powershell
.\scripts\setup-sub2api.ps1
```

检查 Docker 环境：

```powershell
.\scripts\check-sub2api-prereqs.ps1
```

启动服务：

```powershell
.\scripts\start-sub2api.ps1
```

打开管理台：

```text
http://localhost:8080
```

首次启动后，在管理台添加上游账号并生成 API Key。需要让兼容 OpenAI 环境变量的客户端走 Sub2API 时，在当前 PowerShell 会话运行：

```powershell
.\scripts\use-sub2api-openai-env.ps1 -ApiKey "sk-your-sub2api-key"
```

停止服务：

```powershell
.\scripts\stop-sub2api.ps1
```

安全约束：

- 不把 cookie、API Key、账号密码写进仓库。
- 不做自动化网页登录或自动提取 cookie。
- `runtime/sub2api/.env` 是本地运行文件，里面有随机生成的密码和密钥，请勿公开。
