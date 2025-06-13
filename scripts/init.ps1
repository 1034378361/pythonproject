# PowerShell初始化脚本
Write-Host "正在启动项目初始化..." -ForegroundColor Green

# 检查Python是否可用
try {
    $pythonVersion = python --version
    Write-Host "检测到Python: $pythonVersion" -ForegroundColor Cyan
} catch {
    Write-Host "Python未安装或不在PATH中，请先安装Python！" -ForegroundColor Red
    Write-Host "按任意键退出..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# 获取脚本所在目录
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 运行Python初始化脚本
try {
    Write-Host "正在执行初始化..." -ForegroundColor Yellow
    python "$scriptDir\init.py"

    if ($LASTEXITCODE -ne 0) {
        throw "Python脚本返回错误代码: $LASTEXITCODE"
    }

    Write-Host "初始化完成！" -ForegroundColor Green
} catch {
    Write-Host "初始化失败: $_" -ForegroundColor Red
    Write-Host "请检查错误信息。" -ForegroundColor Red
    Write-Host "按任意键退出..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# 保持窗口打开
Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
