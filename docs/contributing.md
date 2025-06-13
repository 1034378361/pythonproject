# PythonProject 贡献指南

欢迎贡献！

## 开发流程

1. 克隆仓库
   ```bash
   git clone git@github.com:1034378361/pythonproject.git
   cd pythonproject
   ```

2. 安装开发依赖
   ```bash
   poetry install --with dev
   ```

3. 激活预提交钩子
   ```bash
   pre-commit install
   ```

4. 创建分支进行开发
   ```bash
   git checkout -b name-of-your-bugfix-or-feature
   ```

5. 进行开发，确保添加测试并通过代码检查
   ```bash
   # 运行测试
   poetry run pytest

   # 格式化代码
   poetry run make format

   # 检查代码
   poetry run make lint
   ```

6. 提交代码，建议使用约定式提交格式
   ```bash
   git add .
   git commit -m "feat: 你的功能描述"
   ```

7. 推送分支并创建拉取请求
   ```bash
   git push origin name-of-your-bugfix-or-feature
   ```

## 拉取请求指南

创建拉取请求前：

1. 更新文档字符串
2. 添加或更新测试用例
3. 确保所有测试通过
4. 确保代码风格检查通过

## 发布流程

1. 更新版本号（在src/pythonproject/_version.py中）
2. 更新CHANGELOG.md
   ```bash
   poetry run make changelog
   ```
3. 提交版本更新
   ```bash
   git add src/pythonproject/_version.py CHANGELOG.md
   git commit -m "release: v版本号"
   ```
4. 创建标签
   ```bash
   git tag v版本号
   ```
5. 推送更新和标签
   ```bash
   git push
   git push --tags
   ```

CI将自动构建并发布到PyPI。

## 详细贡献指南
