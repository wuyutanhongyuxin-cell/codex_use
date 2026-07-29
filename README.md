# codex_use

本仓库用于本地运行 Sub2API，并提供一个 Windows 桌面傻瓜启动器，方便管理多账号 API 网关。

## 文件说明

- `frontend/`：桌面启动器和备用说明页源码。
- `scripts/`：PowerShell 启动、停止、环境变量设置脚本。
- `SUB2API_RUNBOOK.md`：本地运行说明。
- `MULTI_ACCOUNT_TUTORIAL.md`：多账号实现原理和使用教程。
- `codex_multi_account.md`：原始方案笔记。
- `sub2api/`：上游 Sub2API 仓库子模块。

## 快速使用

准备本地运行配置：

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

停止服务：

```powershell
.\scripts\stop-sub2api.ps1
```

首次安装如果 PostgreSQL 显示 unhealthy，可以重建本地容器和卷：

```powershell
.\scripts\reset-sub2api-local.ps1
```

## 多账号教程

见：

```text
MULTI_ACCOUNT_TUTORIAL.md
```

## 克隆本仓库

因为 `sub2api` 是子模块，克隆后需要执行：

```powershell
git submodule update --init --recursive
```

## 安全

`runtime/` 包含本地 `.env`、数据库和密钥，已被 `.gitignore` 忽略，不应上传到 GitHub。
