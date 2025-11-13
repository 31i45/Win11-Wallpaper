# Create Shortcut: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -File "d:\VSCode\RandomWallpaper.ps1"
# Get screen resolution
Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$width, $height = $screen.Bounds.Width, $screen.Bounds.Height

# Random image sources
$source = ("https://picsum.photos/${width}/${height}","https://random.imagecdn.app/${width}/${height}")[(Get-Random 2)]

# Download image to temp file
$tempFile = "$env:TEMP\wallpaper.jpg"
Invoke-WebRequest -Uri $source -OutFile $tempFile

# Set wallpaper
Add-Type -TypeDefinition @"
using System; using System.Runtime.InteropServices; public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(0x0014, 0, $tempFile, 0x0001)

Write-Host "Wallpaper updated successfully"