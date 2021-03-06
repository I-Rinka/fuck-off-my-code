function Convert-Encoding {
    <#
.DESCRIPTION
    Convert-Encoding 将目标文件的字符集转换为给定的字符集

.PARAMETER FilePath
    需要转换的文件的路径，如果是某一路径下的所有文件，则输入string类型的'<path>/*.<拓展名>'

.PARAMETER SouceEncoding
    源文件的字符集，默认是GBK

.PARAMETER TargetEncoding
    转换后的字符集，默认是UTF-8

.EXAMPLE
    Convert-Encoding -FilePath .\锟斤拷.ps1 -SouceEncoding UTF-8 -TargetEncoding GBK

.EXAMPLE
     'Server1', 'Server2' | Get-MrAutoStoppedService

.INPUTS
    String

.OUTPUTS
    File

.NOTES
    Author:  Rinka Wang
    Website: http://I_Rinka@outlook.com
#>
    param (
        $FilePath,
        $SouceEncoding = "GBK",
        $TargetEncoding = "UTF-8"
    )
    Get-ChildItem $FilePath |  foreach-object { 
        
        [void][System.IO.File]::WriteAllBytes($_.FullName, [System.Text.Encoding]::Convert([System.Text.Encoding]::GetEncoding($SouceEncoding), [System.Text.Encoding]::GetEncoding($TargetEncoding), [System.IO.File]::ReadAllBytes($_.FullName)));
        
        # 去除bom，不知道还有没有别的坑
        if ($SouceEncoding -eq "UTF-16" -and $TargetEncoding -eq "UTF-8") {
            $RawString = Get-Content $_ -Tail -4;
            $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
            [System.IO.File]::WriteAllLines($_.FullName, $RawString, $Utf8NoBomEncoding)
        }
        # if ($SouceEncoding -eq "UTF-16") {
        #     Get-Content -Tail -4 $_.FullName | Out-File $_.FullName + "nobom"
        # }
    }; Write-Host '转换完成...'
}

# 如果要让powershell的get-help不乱码，那么需要使用UTF-16