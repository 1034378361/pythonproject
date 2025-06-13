# 版本管理

pythonproject 提供了智能版本管理功能，可以自动检测和使用合适的版本号。

## 版本检测机制

版本检测按以下优先级获取版本号：

1. **Git标签** - 如果项目在Git仓库中并有标签，会使用最近的标签作为版本号
2. **安装信息** - 如果项目已安装，会从安装信息中读取版本
3. **默认版本** - 如上述方法都失败，使用`_version.py`中定义的默认版本

## 使用方法

在代码中获取版本号非常简单：

```python
import pythonproject

# 获取当前版本
version = pythonproject.__version__
print(f"当前版本: {version}")
```

## 原理说明

版本检测的实现在`_version.py`文件中：

```python
# 从Git标签获取版本
def get_version_from_git():
    try:
        # 获取最近的标签
        cmd = ["git", "describe", "--tags", "--abbrev=0"]
        git_tag = subprocess.check_output(cmd, universal_newlines=True).strip()

        # 如果标签以'v'开头，移除'v'
        if git_tag.startswith("v"):
            git_tag = git_tag[1:]

        # 验证版本号格式
        if re.match(r"^\d+\.\d+\.\d+", git_tag):
            return git_tag
    except:
        pass

    return None
```

## 版本发布流程

推荐的发布流程：

1. 更新代码并提交更改
2. 创建版本标签: `git tag -a v0.1.0 -m "Release v0.1.0"`
3. 推送标签: `git push origin v0.1.0`
4. GitHub Actions会自动构建并发布到PyPI

如果使用手动发布流程：

1. 更新代码并提交更改
2. 手动更新`_version.py`中的版本号
3. 按常规流程构建和发布
