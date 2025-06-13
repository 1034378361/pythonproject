#!/usr/bin/env python3
"""
跨平台项目初始化脚本，支持Windows、Linux和macOS。
实现了与init.sh相同的功能。
"""

import os
import platform
import subprocess
import sys
from pathlib import Path
import shutil
from packaging import version


# 彩色输出函数
def log(message):
    """彩色打印日志消息"""
    if platform.system() == "Windows":
        print(f"[init] {message}")
    else:
        print(f"\033[1;32m[init] {message}\033[0m")


def run_command(command, shell=True):
    """运行命令并返回结果"""
    try:
        result = subprocess.run(
            command, shell=shell, check=True, text=True, capture_output=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        log(f"命令执行失败: {e}")
        log(f"错误输出: {e.stderr}")
        return None


def is_command_available(command):
    """检查命令是否可用"""
    if platform.system() == "Windows":
        result = shutil.which(command)
        return result is not None
    else:
        try:
            subprocess.run(
                ["which", command],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            return True
        except subprocess.CalledProcessError:
            return False


def configure_pip_mirror():
    """配置pip国内镜像源"""
    log("配置pip国内镜像源...")

    # 确定pip配置文件路径
    if platform.system() == "Windows":
        pip_conf_dir = Path(os.environ.get("APPDATA")) / "pip"
    else:
        pip_conf_dir = Path.home() / ".config" / "pip"

    pip_conf_dir.mkdir(parents=True, exist_ok=True)

    # 写入pip配置
    pip_conf_file = pip_conf_dir / (
        "pip.ini" if platform.system() == "Windows" else "pip.conf"
    )
    with open(pip_conf_file, "w", encoding="utf-8") as f:
        f.write("[global]\n")
        f.write("index-url = https://mirrors.aliyun.com/pypi/simple/\n")
        f.write("trusted-host = mirrors.aliyun.com\n")


def update_pip():
    """更新pip"""
    log("更新pip...")
    run_command(
        [sys.executable, "-m", "pip", "install", "--upgrade", "pip"], shell=False
    )


def check_python_version():
    """检查Python版本"""
    current_version = platform.python_version()
    required_version = "3.12"
    log(f"当前Python版本: {current_version} (要求版本: {required_version})")

    # 验证版本是否满足要求
    if version.parse(current_version) < version.parse(required_version):
        log(f"警告: 当前Python版本低于要求的最低版本 {required_version}")


def init_git_repo():
    """初始化git仓库（如未初始化）"""
    if not Path(".git").exists():
        log("初始化git仓库...")
        run_command("git init")


def install_pdm():
    """安装PDM"""
    if not is_command_available("pdm"):
        log("安装PDM...")
        run_command(
            [sys.executable, "-m", "pip", "install", "--no-cache-dir", "pdm"],
            shell=False,
        )
        log("PDM安装完成")
    else:
        log("PDM已安装，跳过。")


def configure_pdm():
    """配置PDM国内源"""
    log("配置PDM国内源...")
    run_command("pdm config pypi.url https://mirrors.aliyun.com/pypi/simple/")
    log("PDM配置完成")


def install_pre_commit():
    """安装pre-commit"""
    if not is_command_available("pre-commit"):
        log("安装pre-commit...")
        run_command(
            [sys.executable, "-m", "pip", "install", "--no-cache-dir", "pre-commit"],
            shell=False,
        )
        log("pre-commit安装完成")
    else:
        log("pre-commit已安装，跳过。")


def install_dependencies():
    """安装项目依赖"""
    log("安装项目开发环境依赖...")

    if Path("pyproject.toml").exists():
        log("检测到pyproject.toml，使用PDM安装依赖...")
        run_command("pdm install -d")
        log("项目依赖安装完成")
    elif Path("requirements.txt").exists():
        log("检测到requirements.txt，使用pip安装依赖...")
        run_command(
            [
                sys.executable,
                "-m",
                "pip",
                "install",
                "--no-cache-dir",
                "-r",
                "requirements.txt",
            ],
            shell=False,
        )

        # 检查是否有开发依赖
        if Path("requirements-dev.txt").exists():
            log("安装开发环境依赖...")
            run_command(
                [
                    sys.executable,
                    "-m",
                    "pip",
                    "install",
                    "--no-cache-dir",
                    "-r",
                    "requirements-dev.txt",
                ],
                shell=False,
            )

        log("项目依赖安装完成")
    else:
        log("未检测到依赖文件，跳过依赖安装。")


def setup_pre_commit_hooks():
    """安装并激活pre-commit钩子"""
    if Path(".pre-commit-config.yaml").exists():
        log("检测到.pre-commit-config.yaml，激活pre-commit钩子...")
        run_command("pre-commit install")
        run_command("pre-commit autoupdate")
        log("pre-commit钩子安装完成")
    else:
        log("未检测到.pre-commit-config.yaml，跳过pre-commit钩子安装。")


def generate_env_file():
    """自动生成.env（如有模板）"""
    if Path(".env.example").exists() and not Path(".env").exists():
        log("检测到.env.example，自动生成.env")
        shutil.copy(".env.example", ".env")
        log(".env文件生成完成")
    else:
        log("未检测到.env.example，跳过.env文件生成。")


def install_packaging():
    """确保packaging包已安装"""
    try:
        import packaging
    except ImportError:
        log("安装必要的packaging包...")
        run_command([sys.executable, "-m", "pip", "install", "packaging"], shell=False)
        log("packaging包安装完成")


def main():
    """主函数"""
    log(f"开始在{platform.system()}系统上初始化项目环境...")

    # 确保有packaging包进行版本比较
    install_packaging()

    # 运行初始化步骤
    configure_pip_mirror()
    update_pip()
    check_python_version()
    init_git_repo()
    install_pdm()
    configure_pdm()
    install_pre_commit()
    install_dependencies()
    setup_pre_commit_hooks()
    generate_env_file()

    log("开发环境初始化完成！")


if __name__ == "__main__":
    main()
