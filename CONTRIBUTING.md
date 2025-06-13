# 贡献指南

感谢您考虑为 PythonProject 做出贡献！本文档提供了参与项目开发的指南和最佳实践。

## 开发环境设置

1. Fork项目仓库
2. 克隆你的fork到本地：
   ```bash
   git clone https://github.com/YOUR_USERNAME/pythonproject.git
   cd pythonproject
   ```
3. 设置上游远程：
   ```bash
   git remote add upstream https://github.com/YOUR_USERNAME/pythonproject.git
   ```
4. 创建虚拟环境（推荐使用venv或conda）
5. 安装开发依赖：
   ```bash
   pip install -e ".[dev]"
   ```
6. 安装pre-commit钩子：
   ```bash
   pre-commit install
   ```

## 开发工作流

1. 确保你的main分支是最新的：
   ```bash
   git checkout main
   git pull upstream main
   ```
2. 创建新的功能分支：
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. 进行更改并提交：
   ```bash
   git add .
   git commit -m "feat: 添加了新功能"
   ```
4. 推送到你的fork：
   ```bash
   git push origin feature/your-feature-name
   ```
5. 创建Pull Request

## 代码风格

本项目使用以下工具维护代码质量：

* **Black**：自动格式化代码
* **isort**：整理导入语句
* **Ruff**：代码风格和错误检查
* **mypy**：静态类型检查

在提交前，请确保代码通过了所有检查：

```bash
make lint
```

或者单独运行：

```bash
# 格式化代码
make format

# 类型检查
make type-check
```

## 提交消息规范

我们遵循[约定式提交](https://www.conventionalcommits.org/)规范：

```
<类型>[可选作用域]: <描述>

[可选正文]

[可选脚注]
```

常用类型：

* **feat**：新功能
* **fix**：修复bug
* **docs**：文档变更
* **style**：不影响代码含义的变更（空白、格式化等）
* **refactor**：代码重构
* **test**：添加或修正测试
* **chore**：构建过程或辅助工具变动

示例：
```
feat(cli): 添加新的命令行选项

添加了--verbose选项，用于提供更详细的输出信息。

关闭 #123
```

## 测试

任何新功能或修复都应该包含测试。我们使用pytest进行测试：

```bash
# 运行所有测试
pytest

# 运行特定测试
pytest tests/test_specific.py

# 运行带覆盖率的测试
pytest --cov=pythonproject
```

## 文档

请为所有新功能和API更改添加文档：

1. 更新相关模块、类或函数的文档字符串
2. 如果需要，添加或更新用户指南
3. 确保文档可以正确构建：
   ```bash
   make docs
   ```

## 发布流程

项目维护者负责发布新版本：

1. 更新版本号（在src/pythonproject/_version.py中）
2. 更新CHANGELOG.md
3. 创建新标签并推送
4. GitHub Actions将自动构建并发布到PyPI

## 问题和功能请求

* 使用GitHub Issues报告问题或请求功能
* 在创建新issue前，请检查是否已有类似issue
* 提供尽可能详细的信息，包括重现步骤和预期行为

## 行为准则

请参阅我们的[行为准则](CODE_OF_CONDUCT.md)，以了解我们的社区标准。

## 许可证

通过提交拉取请求，您同意您的贡献将在项目许可证下发布。
