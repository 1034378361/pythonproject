# 工具库

pythonproject 包含一套实用的工具函数，可以帮助您处理常见任务。

## 文件工具

```python
from pythonproject.utils.file_utils import load_json, save_json
```

文件操作工具提供了以下功能：

* **ensure_dir(directory)**: 确保目录存在，不存在则创建
* **load_json(file_path)**: 从JSON文件加载数据
* **save_json(data, file_path, indent=2)**: 保存数据到JSON文件
* **load_yaml(file_path)**: 从YAML文件加载数据
* **save_yaml(data, file_path)**: 保存数据到YAML文件
* **load_pickle(file_path)**: 从Pickle文件加载数据
* **save_pickle(data, file_path)**: 保存数据到Pickle文件
* **list_files(directory, pattern="*", recursive=False)**: 列出目录中符合模式的所有文件
* **get_file_size(file_path, unit='bytes')**: 获取文件大小，支持'bytes'、'KB'、'MB'、'GB'单位

### 示例

```python
from pythonproject.utils.file_utils import ensure_dir, save_json, load_json
from pathlib import Path

# 确保目录存在
data_dir = ensure_dir("./data")

# 保存JSON数据
data = {"name": "test", "values": [1, 2, 3]}
json_file = data_dir / "data.json"
save_json(data, json_file)

# 读取JSON数据
loaded_data = load_json(json_file)
print(loaded_data)  # {'name': 'test', 'values': [1, 2, 3]}
```

## 数据工具

```python
from pythonproject.utils.data_utils import generate_random_string, calculate_md5
```

数据处理工具提供了以下功能：

* **generate_random_string(length=8, include_digits=True)**: 生成随机字符串
* **calculate_md5(data)**: 计算数据的MD5哈希值
* **format_datetime(dt=None, fmt='%Y-%m-%d %H:%M:%S')**: 格式化日期时间
* **parse_datetime(dt_str, fmt='%Y-%m-%d %H:%M:%S')**: 解析日期时间字符串
* **get_date_range(start_date, end_date, fmt='%Y-%m-%d')**: 获取日期范围内的所有日期
* **clean_text(text)**: 清理文本，移除多余空白和特殊字符
* **chunk_list(lst, chunk_size)**: 将列表分割为指定大小的块
* **flatten_dict(d, parent_key='', separator='.')**: 将嵌套字典扁平化

### 示例

```python
from pythonproject.utils.data_utils import generate_random_string, calculate_md5, chunk_list

# 生成随机字符串
random_id = generate_random_string(length=10)
print(random_id)  # 例如: "aB3cDe5fGh"

# 计算MD5
hash_value = calculate_md5("hello world")
print(hash_value)  # "5eb63bbbe01eeed093cb22bb8f5acdc3"

# 分割列表
chunked = chunk_list([1, 2, 3, 4, 5, 6, 7], 3)
print(chunked)  # [[1, 2, 3], [4, 5, 6], [7]]
```

## 日志工具

```python
from pythonproject.utils.logging_utils import setup_logger, get_logger
```

日志工具提供了以下功能：

* **setup_logger(name, level, log_file, log_format, date_format)**: 配置日志记录器
* **get_logger(name)**: 获取预先配置的日志记录器
* **create_rotating_log(log_dir, name, level, max_bytes, backup_count)**: 创建带文件轮转的日志记录器
* **log_function_call(logger, log_args=True)**: 装饰器，记录函数调用信息

### 示例

```python
import logging
from pythonproject.utils.logging_utils import setup_logger, log_function_call

# 创建日志记录器
logger = setup_logger("my_app", level=logging.INFO, log_file="app.log")

# 记录消息
logger.info("应用启动")
logger.warning("发现潜在问题")

# 使用装饰器记录函数调用
@log_function_call(logger)
def process_data(name, value):
    logger.info(f"处理数据 {name}")
    return value * 2

result = process_data("test", 42)  # 自动记录函数调用和参数
```
