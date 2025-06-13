# 使用指南

本文档提供了PythonProject的详细使用说明，包括基本功能、高级特性和最佳实践。

## 基础使用

### 安装

首先，安装PythonProject：

```bash
pip install pythonproject
```

### 导入模块

```python
import pythonproject
from pythonproject import main_function
```

### 基本示例

下面是一个简单的使用示例：

```python
from pythonproject import example_function

# 使用基本功能
result = example_function(parameter="value")
print(result)
```


## 命令行界面

PythonProject提供了基于Typer的命令行界面。

### 基本命令

```bash
# 显示帮助信息
pythonproject --help

# 运行主要功能
pythonproject run --input-file data.txt --output-file results.txt

# 查看版本
pythonproject --version
```

### 命令示例

以下是一些常用命令示例：

```bash
# 处理数据示例
pythonproject process --input data.csv --output results.csv

# 启用详细日志
pythonproject run --verbose

# 设置配置选项
pythonproject run --config config.yml
```


## 高级用法

### 配置选项

PythonProject支持以下配置方式：

1. 代码中直接配置
2. 配置文件（YAML/JSON）
3. 环境变量

#### 代码配置

```python
from pythonproject import configure

# 设置全局配置
configure(
    option1="value1",
    option2=42,
    debug=True
)

# 使用上下文管理器临时配置
with configure(debug=True):
    # 在此代码块中使用特定配置
    result = complex_operation()
```

#### 配置文件

创建配置文件`config.yml`：

```yaml
option1: value1
option2: 42
debug: true
advanced:
  setting1: value
  setting2: value
```

加载配置：

```python
from pythonproject import load_config

config = load_config("config.yml")
```

#### 环境变量

环境变量会覆盖配置文件中的同名选项：

```bash
export PYTHONPROJECT_OPTION1=value1
export PYTHONPROJECT_DEBUG=true
```

### 错误处理

PythonProject提供自定义异常类，方便错误处理：

```python
from pythonproject import process_data
from pythonproject.exceptions import ValidationError, ProcessingError

try:
    result = process_data(input_data)
except ValidationError as e:
    print(f"输入数据无效: {e}")
except ProcessingError as e:
    print(f"处理过程中出错: {e}")
except Exception as e:
    print(f"未知错误: {e}")
```

## 性能优化

为了获得最佳性能，请考虑以下建议：

1. 对于大型数据集，使用批处理模式
2. 启用缓存机制减少重复计算
3. 在多线程环境中使用线程安全的API

示例：

```python
from pythonproject import process_batch, enable_cache

# 启用缓存
enable_cache()

# 批处理大型数据集
for batch in data_chunks:
    result = process_batch(batch)
    # 处理结果
```

## 实际应用场景

### 场景一：数据处理

```python
from pythonproject import DataProcessor

# 创建处理器
processor = DataProcessor()

# 加载数据
processor.load_data("input.csv")

# 应用转换
processor.transform(normalize=True, remove_outliers=True)

# 保存结果
processor.save("output.csv")
```



## 最佳实践

1. **合理配置**：根据数据规模和处理需求调整配置参数
2. **错误处理**：始终使用try-except捕获并处理可能的异常
3. **资源管理**：使用上下文管理器确保资源正确释放
4. **日志记录**：在生产环境中启用日志记录功能
5. **性能监控**：对于长时间运行的任务，使用内置的性能监控工具

示例：

```python
import logging
from pythonproject import setup_logging, LongRunningTask

# 配置日志
setup_logging(level=logging.INFO)

# 创建任务并启用监控
task = LongRunningTask(monitoring=True)

# 使用上下文管理器确保资源释放
with task.execute() as result:
    # 处理结果
    data = result.get_data()
```

## 常见问题

### Q: 如何处理大型数据集？

A: 使用批处理模式并调整内存配置：

```python
from pythonproject import configure, process_large_dataset

configure(batch_size=1000, memory_limit="2GB")
process_large_dataset("large_file.csv", output="results.csv")
```

### Q: 如何调试复杂问题？

A: 启用详细日志并使用内置的调试工具：

```python
from pythonproject import configure, debug_mode

configure(log_level="DEBUG")
with debug_mode():
    # 执行问题代码
    result = complex_function()
```

### Q: 配置参数的优先级是什么？

A: 参数优先级从高到低：
1. 函数直接参数
2. 环境变量
3. 配置文件
4. 默认值
