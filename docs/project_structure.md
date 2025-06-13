# 项目结构概述

本文档提供了项目的目录结构和主要文件的概述，帮助您快速了解项目组织方式。

## 顶层目录结构

```
pythonproject/
├── docs/               # 项目文档
├── scripts/            # 辅助脚本
├── src/                # 源代码
│   └── pythonproject/  # 主包
├── tests/              # 测试文件
├── .github/            # GitHub配置
├── .vscode/            # VS Code配置
├── pyproject.toml      # 项目配置和依赖管理
├── setup.py            # 跨平台安装脚本
├── Makefile            # 项目命令
└── README.md           # 项目说明
```

## 核心组件

### 源代码 (`src/`)

源代码目录使用src布局，这是Python项目的推荐做法，有助于避免导入问题和测试隔离。

```
src/pythonproject/
├── __init__.py         # 包初始化
├── _version.py         # 版本信息
├── pythonproject.py  # 主模块

├── cli.py              # 命令行界面

└── utils/              # 实用工具
    ├── __init__.py
    ├── data_utils.py   # 数据处理工具
    ├── file_utils.py   # 文件操作工具
    └── logging_utils.py # 日志工具
```

### 测试 (`tests/`)

测试目录包含所有测试文件，使用pytest框架。

```
tests/
├── __init__.py
├── conftest.py         # 共享测试配置和fixtures
├── test_pythonproject.py  # 主模块测试
└── test_utils.py       # 工具函数测试
```

### 文档 (`docs/`)

文档目录使用MkDocs生成项目文档，包含API参考和使用指南。

```
docs/
├── api/                # API参考文档
├── _includes/          # 可重用文档片段
├── css/                # 自定义样式
├── index.md            # 文档首页
├── installation.md     # 安装指南
├── usage.md            # 使用指南
├── project_structure.md # 项目结构概述(本文档)
└── contributing.md     # 贡献指南
```

### 脚本 (`scripts/`)

辅助脚本目录包含各种自动化工具。

```
scripts/
├── __init__.py
├── docker.py           # Docker操作工具(跨平台)
├── generate_changelog.py  # 变更日志生成工具
└── init.sh             # 环境初始化脚本
```

### CI/CD配置 (`.github/`)

GitHub Actions工作流配置。

```
.github/
├── workflows/
│   ├── ci.yml          # 统一CI/CD工作流(测试、质量检查、发布)
│   └── dependabot.yml  # 依赖更新配置
└── ISSUE_TEMPLATE.md   # Issue模板
```

## 主要配置文件

### pyproject.toml

现代Python项目的核心配置文件，包含:

- 项目元数据和描述
- 依赖管理(核心依赖和开发依赖)
- 构建系统配置
- 开发工具配置:
  - Ruff: 代码质量检查和格式化
  - Mypy: 静态类型检查
  - Pytest: 测试配置
  - 覆盖率报告配置

### Makefile

提供跨平台的项目命令:

- `make help` - 显示可用命令
- `make test` - 运行测试
- `make lint` - 运行代码质量检查
- `make format` - 格式化代码
- `make docs` - 构建文档
- `make setup` - 运行安装脚本
- `make venv` - 创建虚拟环境
- `make docker-build` - 构建Docker镜像
- `make docker-run` - 运行Docker容器

### setup.py

跨平台安装脚本，功能包括:

- 自动检测操作系统
- 创建虚拟环境
- 安装项目依赖(基础或开发版本)
- 配置开发环境(git hooks等)
- 支持无提示模式，适用于CI环境

## Docker支持

项目内置Docker支持:

- `Dockerfile` - 定义容器环境
- `docker-compose.yml` - 定义服务配置
- `scripts/docker.py` - 跨平台Docker操作脚本

## 开发工具与流程

### 代码质量工具

- **Ruff**: 集成了多种工具功能，包括linting和格式化
- **Mypy**: 静态类型检查
- **Pre-commit**: Git提交钩子，确保代码质量

### 测试工具

- **Pytest**: 测试框架
- **Coverage**: 代码覆盖率报告
- **Tox**: 多环境测试

### 文档工具

- **MkDocs**: 文档生成
- **Material for MkDocs**: 主题
- **MkDocStrings**: API文档自动生成

### 发布流程

1. 更新版本号(`src/pythonproject/_version.py`)
2. 推送标签(`git tag vX.Y.Z`)
3. CI自动构建并发布到PyPI
4. 自动更新CHANGELOG并创建GitHub Release

## 最佳实践

- 使用虚拟环境隔离项目依赖
- 遵循代码风格指南
- 编写测试和文档
- 使用类型注解
- 遵循语义化版本控制
- 使用分支开发新功能
