$src ="\\tmn-mgmt-03\c$\UTA\ARC"
$dst = "L:\PTK PSD\Post\Store"
$dir1 = Split-Path -Path $myInvocation.MyCommand.Path -Parent
$err = $dir1

$err_log = -join ($err, "\error.log")

if (Test-Path $err_log){
    Remove-Item $err_log
}
    
if (-Not (Test-Path $src)){
    $encoding = [System.Text.Encoding]::UTF8
    Send-MailMessage -from "robot@tmn.apkbank.apk" -to "tmn_oit@tmn.apkbank.apk" -Encoding $encoding -subject "Ошибка соединения" -body "Ошибка соединения с $src" -smtpServer 191.168.6.50
    Write-Host "Ошибка соединения с $src" -ForegroundColor "red"
    Exit
}

if (-Not (Test-Path $dst)){
    $encoding = [System.Text.Encoding]::UTF8
    Send-MailMessage -from "robot@tmn.apkbank.apk" -to "tmn_oit@tmn.apkbank.apk" -Encoding $encoding -subject "Ошибка соединения" -body "Ошибка соединения с $dst" -smtpServer 191.168.6.50
    Write-Host "Ошибка соединения с $dst" -ForegroundColor "red"
    Exit
}

Clear-Host

foreach ($path in Get-ChildItem $src){
    $date1 = $path.Name
    
    if ($date1 -ne "UTA"){        
        $y1 =$path.Name.Substring(0,4)
        $m1 =$path.Name.Substring(4,2)
        $d1 =$path.Name.Substring(6,2)
    
        $src_path1 = "$src\$date1\INFO_IN\"
        if ( -Not (Test-Path $src_path1) ){
            continue
        }        
        
        $dst_path1 = "$dst\$y1\$m1\$d1\"
        if ( -Not (Test-Path $dst_path1) ){
            continue
        }
        
        $src_files = Get-ChildItem $src_path1 "*.962"
        $dst_files = Get-ChildItem $dst_path1 "*.962.*"
        
        Write-Host $src_path1 -ForegroundColor "green"
        
        foreach ($src1 in $src_files){            
            if (-Not ($dst_files -match $src1.Name)){
                $name1 = $src1.Name
                Write-Host "$src_path1$name1" -ForegroundColor "red"
                Add-Content -path $err_log -value "$src_path1$name1"
                #Copy-Item "$src_path1$name1" -Destination $err 
            }            
        }
     }
}

if (Test-Path $err_log){
    $str1  = Get-Content $err_log | Out-String
    $str1 = -join ("Подгрузите в ПТК ПСД `r`n", $str1)
    $encoding = [System.Text.Encoding]::UTF8
    Send-MailMessage -from "robot@tmn.apkbank.apk" -to "tmn_oit@tmn.apkbank.apk" -Priority High -Encoding $encoding -subject "Утеряна посылка из ЦБ (UTA)" -body $str1 -smtpServer 191.168.6.50
}