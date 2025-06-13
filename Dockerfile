###############
# 构建阶段
###############
FROM python:3.12-slim-bookworm AS builder

WORKDIR /app

# 设置构建环境变量
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_NO_INTERACTION=1

# 安装构建依赖 - 仅安装必要的包
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 首先复制依赖文件，利用Docker缓存层
COPY pyproject.toml README.md ./

# 复制源代码
COPY src ./src/

# 安装依赖并构建wheel包
RUN pip wheel --no-deps --no-cache-dir --wheel-dir /app/wheels -e .

###############
# 最终运行阶段
###############
FROM python:3.12-slim-bookworm

# 设置标签，提供镜像元数据
LABEL maintainer="Zhou Yuanqi <zyq1034378361@gmail.com>" \
      name="pythonproject" \
      version="0.1.0" \
      description="Python项目模板，包含创建Python包所需的所有基础结构。"

# 创建非root用户
RUN groupadd -g 1000 appgroup && \
    useradd -u 1000 -g appgroup -m -s /bin/bash appuser

# 设置工作目录
WORKDIR /app

# 设置运行环境变量
ENV PYTHONPATH=/app \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONHASHSEED=random

# 从构建阶段复制wheel包和必要文件
COPY --from=builder /app/wheels /app/wheels
COPY --from=builder /app/src ./src

# 安装应用并清理
RUN pip install --no-cache-dir /app/wheels/*.whl && \
    rm -rf /app/wheels && \
    find /usr/local -type d -name __pycache__ -exec rm -rf {} +

# 安全措施：设置正确的文件权限
RUN chown -R appuser:appgroup /app && \
    chmod -R 755 /app

# 切换到非root用户
USER appuser

# 健康检查 - 每30秒检查一次
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \

    CMD pythonproject --version || exit 1


# 设置资源限制
ENV MALLOC_ARENA_MAX=2

# 容器启动命令

ENTRYPOINT ["pythonproject"]
CMD ["--help"]
