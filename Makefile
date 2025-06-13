.PHONY: clean clean-build clean-pyc clean-test coverage dist docs help install dev-install \
	lint format test test-all release docker docker-build docker-run setup venv check-update pre-commit \
	full-install

.DEFAULT_GOAL := help

# 创建跨平台辅助脚本
define HELPER_SCRIPT
#!/usr/bin/env python3
"""Cross-platform Makefile helper script."""

import os
import re
import sys
import shutil
import webbrowser
from pathlib import Path
from urllib.request import pathname2url


def open_browser(filepath):
    """Open file in default web browser."""
    url = 'file://' + pathname2url(os.path.abspath(filepath))
    webbrowser.open(url)


def print_help(makefile):
    """Print help info from Makefile."""
    with open(makefile, 'r') as f:
        for line in f:
            match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
            if match:
                target, help = match.groups()
                print(f"{target:20} {help}")


def clean_paths(paths):
    """Remove specified files and directories."""
    for path_pattern in paths:
        for path in Path('.').glob(path_pattern):
            if path.is_dir():
                print(f"Removing directory: {path}")
                shutil.rmtree(path, ignore_errors=True)
            elif path.is_file():
                print(f"Removing file: {path}")
                path.unlink()


def check_content(pattern, directories):
    """Check files in directories for matching pattern."""
    found = False
    regex = re.compile(pattern)

    for directory in directories:
        for root, _, files in os.walk(directory):
            for file in files:
                if not file.endswith(('.py', '.md', '.rst', '.txt')):
                    continue

                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        if regex.search(content):
                            print(f"Match found in {filepath}")
                            found = True
                except Exception as e:
                    print(f"Could not read {filepath}: {e}")

    return found


if __name__ == "__main__":
    command = sys.argv[1] if len(sys.argv) > 1 else "help"

    if command == "browser" and len(sys.argv) > 2:
        open_browser(sys.argv[2])
    elif command == "help" and len(sys.argv) > 2:
        print_help(sys.argv[2])
    elif command == "clean" and len(sys.argv) > 2:
        clean_paths(sys.argv[2:])
    elif command == "check" and len(sys.argv) > 3:
        pattern = sys.argv[2]
        dirs = sys.argv[3:]
        found = check_content(pattern, dirs)
        sys.exit(1 if found else 0)
    else:
        print(f"Unknown or incomplete command: {' '.join(sys.argv[1:])}")
        sys.exit(1)

endef
export HELPER_SCRIPT

# 创建辅助脚本
$(shell echo "$$HELPER_SCRIPT" > .make_helper.py && chmod +x .make_helper.py)


help: ## 显示帮助信息
	@python .make_helper.py help $(MAKEFILE_LIST)

clean: clean-build clean-pyc clean-test ## 删除所有构建、测试和Python缓存文件

clean-build: ## 删除构建产物
	@python .make_helper.py clean "build/*" "dist/*" ".eggs/*" "*.egg-info" "*.egg"

clean-pyc: ## 删除Python编译缓存
	@python .make_helper.py clean "**/*.pyc" "**/*.pyo" "**/*~" "**/__pycache__"

clean-test: ## 删除测试缓存和覆盖率报告
	@python .make_helper.py clean ".tox" ".coverage" "htmlcov" ".pytest_cache"

lint: ## 运行代码质量检查
	ruff check src tests
	ruff format --check src tests
	mypy src
	# 检查调试语句和合并冲突
	@python .make_helper.py check "(import pdb|breakpoint\(\)|<<<<<<< HEAD)" src tests docs || (echo "错误: 发现调试语句或合并冲突"; exit 1)

format: ## 格式化代码
	ruff format src tests
	ruff check --fix src tests

test: ## 运行测试
	pytest --cov=src --cov-report=term --cov-report=html --cov-report=xml --cov-fail-under=85

test-all: ## 使用tox运行多环境测试
	pdm run tox

test-parallel: ## 并行运行测试以提高速度
	pytest -xvs --cov=src -n auto

coverage: ## 检查代码覆盖率
	pytest --cov=src --cov-report=term --cov-report=html
	python .make_helper.py browser htmlcov/index.html

docs: ## 生成MkDocs文档
	pdm run mkdocs build
	python .make_helper.py browser site/index.html

servedocs: ## 启动文档服务器，支持实时重载
	pdm run mkdocs serve

release: dist ## 打包并发布
	pdm publish

dist: clean ## 构建源码和wheel包
	pdm build
	@echo "构建的分发包:"
	@ls -l dist

install: clean ## 安装包
	pip install .

dev-install: clean ## 安装包和开发依赖
	pip install -e ".[dev]"

full-install: clean ## 安装包和所有开发依赖（包括项目类型特定依赖）
	pip install -e ".[full-dev]"

pdm-install: clean ## 使用PDM安装包和开发依赖
	pdm install -d

pdm-full-install: clean ## 使用PDM安装包和所有开发依赖
	pdm install -G full-dev

venv: ## 创建虚拟环境并安装开发依赖
	python -m venv .venv
	.venv/bin/pip install -U pip
	.venv/bin/pip install -e ".[dev]"
	@echo "虚拟环境创建成功!"
	@echo "使用 'source .venv/bin/activate' (Linux/Mac) 或 '.venv\\Scripts\\activate' (Windows) 激活环境"

setup: ## 运行统一安装脚本
	python setup.py

bump-version: ## 更新项目版本号 (使用: make bump-version PART=minor)
	bump2version $(PART)







docker-build: ## 构建Docker镜像
	python scripts/docker.py build

docker-run: ## 运行Docker容器
	python scripts/docker.py run -i

pre-commit: ## 安装pre-commit钩子
	pip install pre-commit
	pre-commit install

check-update: ## 检查依赖更新
	pdm update --dry-run

changelog: ## 生成变更日志
	@echo "正在生成变更日志..."
	@if [ -f "scripts/generate_changelog.py" ]; then \
		python scripts/generate_changelog.py; \
	else \
		echo "变更日志脚本不存在，请确认项目配置"; \
	fi
