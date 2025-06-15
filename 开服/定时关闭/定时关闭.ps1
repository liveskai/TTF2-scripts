# 获取所有服务器 的 PID，只获取一次
$procs = Get-Process NorthstarLauncher -ErrorAction SilentlyContinue

if ($procs.Count -eq 0)
{
	Write-Host "找不到程序"
	Start-Sleep -Seconds 10
	exit
}

# 遍历每个进程，每隔1分钟 kill 一个
foreach ($proc in $procs)
{
	Write-Host "Killing PID $($proc.Id)"
	Stop-Process -Id $proc.Id -Force
	Start-Sleep -Seconds 60
}

Write-Host "已关闭所有程序"
Start-Sleep -Seconds 10
exit