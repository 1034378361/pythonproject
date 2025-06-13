#!/usr/bin/env python3
"""
跨平台Docker操作脚本。

此脚本提供构建和运行Docker容器的功能，适用于所有平台。
替代了平台特定的shell和batch脚本。
"""

import argparse
import os
import platform
import subprocess
import sys
from pathlib import Path


def get_project_root():
    """获取项目根目录。"""
    # 假设脚本位于项目的scripts目录下
    return Path(__file__).parent.parent.absolute()


def get_project_name():
    """从目录名获取项目名称。"""
    return get_project_root().name


def build_docker_image(tag=None, dockerfile=None, build_args=None):
    """构建Docker镜像。"""
    project_root = get_project_root()
    project_name = get_project_name()

    if tag is None:
        tag = f"{project_name}:latest"

    if dockerfile is None:
        dockerfile = project_root / "Dockerfile"
        if not dockerfile.exists():
            print(f"错误: 未找到Dockerfile在 {dockerfile}", file=sys.stderr)
            return False

    cmd = ["docker", "build", "-t", tag, "-f", str(dockerfile), "."]

    if build_args:
        for arg_name, arg_value in build_args.items():
            cmd.extend(["--build-arg", f"{arg_name}={arg_value}"])

    print(f"构建Docker镜像: {tag}")
    print(f"命令: {' '.join(cmd)}")

    try:
        subprocess.run(cmd, check=True, cwd=project_root)
        print(f"Docker镜像 {tag} 构建成功!")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Docker镜像构建失败: {e}", file=sys.stderr)
        return False


def run_docker_container(
    tag=None,
    ports=None,
    volumes=None,
    env_vars=None,
    command=None,
    interactive=False,
    remove=True,
):
    """运行Docker容器。"""
    project_name = get_project_name()

    if tag is None:
        tag = f"{project_name}:latest"

    cmd = ["docker", "run"]

    if interactive:
        cmd.extend(["-it"])

    if remove:
        cmd.append("--rm")

    if ports:
        for host_port, container_port in ports.items():
            cmd.extend(["-p", f"{host_port}:{container_port}"])

    if volumes:
        for host_path, container_path in volumes.items():
            cmd.extend(["-v", f"{host_path}:{container_path}"])

    if env_vars:
        for var_name, var_value in env_vars.items():
            cmd.extend(["-e", f"{var_name}={var_value}"])

    cmd.append(tag)

    if command:
        cmd.extend(command if isinstance(command, list) else [command])

    print(f"运行Docker容器: {tag}")
    print(f"命令: {' '.join(cmd)}")

    try:
        subprocess.run(cmd, check=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Docker容器运行失败: {e}", file=sys.stderr)
        return False


def parse_args():
    """解析命令行参数。"""
    parser = argparse.ArgumentParser(description="Docker操作工具")
    subparsers = parser.add_subparsers(dest="command", help="要执行的命令")

    # 构建命令
    build_parser = subparsers.add_parser("build", help="构建Docker镜像")
    build_parser.add_argument("-t", "--tag", help="Docker镜像标签")
    build_parser.add_argument("-f", "--dockerfile", help="Dockerfile路径")
    build_parser.add_argument(
        "--build-arg", action="append", help="构建参数 (格式: KEY=VALUE)"
    )

    # 运行命令
    run_parser = subparsers.add_parser("run", help="运行Docker容器")
    run_parser.add_argument("-t", "--tag", help="Docker镜像标签")
    run_parser.add_argument(
        "-p", "--port", action="append", help="端口映射 (格式: HOST:CONTAINER)"
    )
    run_parser.add_argument(
        "-v", "--volume", action="append", help="卷映射 (格式: HOST:CONTAINER)"
    )
    run_parser.add_argument(
        "-e", "--env", action="append", help="环境变量 (格式: KEY=VALUE)"
    )
    run_parser.add_argument("-i", "--interactive", action="store_true", help="交互模式")
    run_parser.add_argument("--no-rm", action="store_true", help="容器退出后不自动删除")
    run_parser.add_argument("command", nargs="*", help="容器内要运行的命令")

    return parser.parse_args()


def main():
    """主函数。"""
    args = parse_args()

    if args.command == "build":
        build_args = {}
        if args.build_arg:
            for arg in args.build_arg:
                if "=" in arg:
                    key, value = arg.split("=", 1)
                    build_args[key] = value

        return build_docker_image(
            tag=args.tag, dockerfile=args.dockerfile, build_args=build_args
        )

    elif args.command == "run":
        ports = {}
        if args.port:
            for port in args.port:
                if ":" in port:
                    host, container = port.split(":", 1)
                    ports[host] = container

        volumes = {}
        if args.volume:
            for volume in args.volume:
                if ":" in volume:
                    host, container = volume.split(":", 1)
                    volumes[host] = container

        env_vars = {}
        if args.env:
            for env in args.env:
                if "=" in env:
                    key, value = env.split("=", 1)
                    env_vars[key] = value

        return run_docker_container(
            tag=args.tag,
            ports=ports,
            volumes=volumes,
            env_vars=env_vars,
            command=args.command,
            interactive=args.interactive,
            remove=not args.no_rm,
        )

    else:
        print("错误: 请指定一个命令 (build 或 run)", file=sys.stderr)
        return False


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
