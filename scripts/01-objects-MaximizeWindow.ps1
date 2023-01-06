function Show-Process($Process, [Switch]$Maximize) {
    <# Function Courtsy of: community.idera.com/database-tools/powershell/powertips/b/tips/posts/bringing-window-in-the-foreground#>
    $sig = '
    [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
  '
    if ($Maximize) { $Mode = 3 } else { $Mode = 4 }
    $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
    $hwnd = $process.MainWindowHandle
    $null = $type::ShowWindowAsync($hwnd, $Mode)
    $null = $type::SetForegroundWindow($hwnd)
}

$notepadId = (Get-process -name "Notepad*" | Select-Object -First 1).ID
Show-Process -Process (Get-Process -Id $notepadId) -Maximize
