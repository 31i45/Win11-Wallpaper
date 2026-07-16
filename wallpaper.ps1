param([switch]$LockScreen)

# 下载
$tmp = Join-Path $env:TEMP "wp_$(Get-Random).jpg"
Invoke-WebRequest 'https://picsum.photos/2560/1440' -OutFile $tmp -TimeoutSec 30

# 设置
if ($LockScreen) {
    $dest = Join-Path $env:ProgramData 'Microsoft\Lockscreen\Lockscreen.jpg'
    Copy-Item $tmp $dest -Force
    $reg = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'
    if (!(Test-Path $reg)) { New-Item $reg -Force | Out-Null }
    Set-ItemProperty $reg -Name LockScreenImagePath -Value $dest
    Set-ItemProperty $reg -Name LockScreenImageStatus -Value 1 -Type DWord
    Set-ItemProperty $reg -Name LockScreenImageUrl -Value ''
} else {
    $dest = Join-Path $env:LOCALAPPDATA 'Wallpaper.jpg'
    Copy-Item $tmp $dest -Force
    if (-not ('Wallpaper' -as [type])) {
        Add-Type -TypeDefinition @'
        using System.Runtime.InteropServices;
        public class Wallpaper {
            [DllImport("user32.dll", CharSet = CharSet.Unicode)]
            static extern int SystemParametersInfo(int a, int b, string c, int d);
            public static void Set(string path) { SystemParametersInfo(0x14, 0, path, 0x03); }
        }
'@
    }
    [Wallpaper]::Set($dest)
}

# 清理
Remove-Item $tmp -Force -ErrorAction SilentlyContinue
