$dir1 = Split-Path -Path $myInvocation.MyCommand.Path -Parent

#$arj_file = "$dir1\DAT\_dat.arj"
#$bik_dir = "$dir1\bik1"
#$upd_dir = "$dir1\Update"

$arj_file = "c:\UTA\SR\KONTR\BIK\DAT\_dat.arj"
$bik_dir = "\\tmn-eed-01\Bik"
$upd_dir = "\\3170-file\quo_l\BIKViewer\Update"

Set-Location $dir1

Clear-Host

if (!(Test-Path -Path $arj_file )){
	Write-Host -ForegroundColor Red "Файл $arj_file не найден!"
	exit
}

if (!(Test-Path -Path $bik_dir )){
	Write-Host -ForegroundColor Red "Каталог $bik_dir не найден!"
	exit
}

if (!(Test-Path -Path $upd_dir )){
	Write-Host -ForegroundColor Red "Каталог $upd_dir не найден!"
	exit
}

$tmp_dir = "$dir1\tmp"
if (!(Test-Path -Path $tmp_dir )){
	New-Item -ItemType directory $tmp_dir -Force | out-null	
} else {
	Remove-Item $tmp_dir -Force -Recurse
	New-Item -ItemType directory $tmp_dir -Force | out-null	
}

Write-Host -ForegroundColor Green "Разархивирем во временный каталог"
$AllArgs = @('e', $arj_file, $tmp_dir)
&"$dir1\arj32.exe" $AllArgs > $null

Remove-Item "$bik_dir\*.*" -Force
Remove-Item "$upd_dir\*.*" -Force

Write-Host -ForegroundColor Green "Копируем файлы в каталоги"
Copy-Item "$tmp_dir\*.*" -Destination $bik_dir
Copy-Item "$tmp_dir\*.*" -Destination $upd_dir

Remove-Item $tmp_dir -Force -Recurse