# 开发者指南

本文档提供项目开发相关的信息和指南。

## 开发环境设置

### 使用开发容器 (推荐)

本项目包含基于**CentOS 7.5.1804**的开发容器配置，与生产环境保持一致，确保开发测试在实际部署时的行为一致性。

#### 前提条件
- 安装 [Docker](https://www.docker.com/get-started)
- 安装 [Visual Studio Code](https://code.visualstudio.com/)
- 安装 VS Code的 [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) 扩展

#### 使用步骤
1. 用VS Code打开项目文件夹
2. 在VS Code的命令面板中(Ctrl+Shift+P或Cmd+Shift+P)，执行"Remote-Containers: Reopen in Container"命令
3. VS Code将构建容器并在容器内打开项目，首次构建可能需要5-10分钟时间
4. 容器启动后，所有依赖和工具已预先配置好，可以立即开始开发

#### 开发容器特性
- 使用CentOS 7.5.1804基础镜像，与生产环境一致
- Python 3.10.6环境，预编译安装
- 预安装开发工具：pytest, black, isort, ruff, mypy等
- 预配置的VS Code设置和扩展
- 自动安装项目依赖
- 自动设置pre-commit钩子

#### CentOS 7特别说明
- 系统采用较旧但更稳定的CentOS 7.5版本
- 默认Python为手动编译的3.10.6版本
- CentOS 7上编译安装Python 3.10需要更长时间，请耐心等待
- 一些系统工具和库版本较老，与生产环境保持一致

### 手动设置

如果不使用开发容器，可以按照以下步骤手动设置开发环境：

1. 创建并激活虚拟环境：
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/macOS
   # 或
   venv\Scripts\activate  # Windows
   ```

2. 安装开发依赖：
   ```bash
   pip install -e ".[dev]"
   ```

3. 安装pre-commit钩子：
   ```bash
   pre-commit install
   ```

## 开发工作流程

### 运行测试
```bash
pytest
```

### 代码风格检查
```bash
# 使用ruff进行代码格式化
ruff format src tests

# 使用ruff进行静态检查（包括文档字符串检查）
ruff check src tests

# 使用black格式化代码（备选方法）
black src tests

# 使用isort排序导入（备选方法）
isort src tests

# 类型检查
mypy src

# 一步完成所有检查
make lint

# 一步完成所有格式化
make format
```

### 更新CHANGELOG
```bash
# 从最新标签生成
make changelog

# 生成完整历史
make changelog-init
```

### 构建文档
```bash
# 生成HTML文档
make docs
```

### 发布流程
```bash
# 构建分发包
make dist

# 上传到PyPI
make release
```

## 类型检查

本项目使用mypy进行静态类型检查，确保代码类型安全。

### 运行类型检查

```bash
# 基本类型检查
mypy src

# 带详细报告的类型检查
mypy --show-error-codes --pretty src

# 生成HTML报告
mypy --html-report mypy-report src
```

### 类型检查配置

项目在`pyproject.toml`中配置了mypy，主要设置包括：

```toml
[tool.mypy]
files = "src"
python_version = "312"
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
disallow_untyped_decorators = true
no_implicit_optional = true
strict_optional = true
```

### 类型注解最佳实践

1. **所有函数添加类型注解**：
   ```python
   def process_data(data: Dict[str, Any]) -> List[str]:
       # ...
   ```

2. **使用类型别名简化复杂类型**：
   ```python
   from typing import Dict, List, TypeAlias

   JSONData: TypeAlias = Dict[str, Any]

   def process_json(data: JSONData) -> JSONData:
       # ...
   ```

3. **正确使用Optional和Union**：
   ```python
   from typing import Optional, Union

   def find_user(user_id: Optional[int] = None,
                 username: Optional[str] = None) -> Union[User, None]:
       # ...
   ```

4. **集合类型使用泛型参数**：
   ```python
   def get_user_ids(users: List[User]) -> Set[int]:
       # ...
   ```

5. **标注异步函数**：
   ```python
   async def fetch_data() -> Dict[str, Any]:
       # ...
   ```

### CI中的类型检查

项目配置了两种类型检查CI流程：

1. **Pull Request检查**：每次PR都会运行基本类型检查，确保代码质量
2. **深度类型检查**：每周自动运行一次完整类型检查，生成类型覆盖率报告
