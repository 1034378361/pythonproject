#!/bin/bash
set -e

# export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

log() { echo -e "\033[1;32m[init] $1\033[0m"; }

# 配置全局pip镜像源
log "配置pip国内镜像源..."
mkdir -p ~/.config/pip
cat > ~/.config/pip/pip.conf << EOF
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/
trusted-host = mirrors.aliyun.com
EOF

# 更新pip
log "更新pip..."
pip install --upgrade pip

# 检查Python版本
python_version=$(python --version | cut -d ' ' -f 2)
required_version="3.12"
log "当前Python版本: $python_version (要求版本: $required_version)"

# 初始化git仓库（如未初始化）
if [ ! -d .git ]; then
  log "初始化git仓库..."
  git init
fi

# 安装PDM
if ! command -v pdm &> /dev/null; then
  log "安装PDM..."
  # 使用pip安装PDM
  pip install --no-cache-dir pdm
  log "PDM安装完成"
else
  log "PDM已安装，跳过。"
fi

log "配置PDM国内源..."
# 配置PDM国内源
pdm config pypi.url https://mirrors.aliyun.com/pypi/simple/
# 保留缓存以提高性能
log "PDM配置完成"

# 安装pre-commit
if ! command -v pre-commit &> /dev/null; then
  log "安装pre-commit..."
  pip install --no-cache-dir pre-commit
  log "pre-commit安装完成"
else
  log "pre-commit已安装，跳过。"
fi

# 确保安装开发环境依赖
log "安装项目开发环境依赖..."
if [ -f pyproject.toml ]; then
  log "检测到pyproject.toml，使用PDM安装依赖..."
  pdm install -d
  log "项目依赖安装完成"
elif [ -f requirements.txt ]; then
  log "检测到requirements.txt，使用pip安装依赖..."
  pip install --no-cache-dir -r requirements.txt
  if [ -f requirements-dev.txt ]; then
    log "安装开发环境依赖..."
    pip install --no-cache-dir -r requirements-dev.txt
  fi
  log "项目依赖安装完成"
else
  log "未检测到依赖文件，跳过依赖安装。"
fi

# 安装并激活pre-commit钩子
if [ -f .pre-commit-config.yaml ]; then
  log "检测到.pre-commit-config.yaml，激活pre-commit钩子..."
  pre-commit install
  pre-commit autoupdate
  log "pre-commit钩子安装完成"
else
  log "未检测到.pre-commit-config.yaml，跳过pre-commit钩子安装。"
fi

# 自动生成.env（如有模板）
if [ -f .env.example ] && [ ! -f .env ]; then
  log "检测到.env.example，自动生成.env"
  cp .env.example .env
  log ".env文件生成完成"
else
  log "未检测到.env.example，跳过.env文件生成。"
fi

log "容器开发环境初始化完成！"
