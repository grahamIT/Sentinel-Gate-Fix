Copyright © 2022 Graham Investments

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#Define Functions
function printOut($Message) {
echo "--------------------------------------"
echo $Message
echo "--------------------------------------"
echo ""
}

#Start of script

#Get Admin
if (!
    #current role
    (New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    #is admin?
    )).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
) {
    #elevate script and exit current non-elevated runtime
    Start-Process `
        -FilePath 'powershell' `
        -ArgumentList (
            #flatten to single array
            '-File', $MyInvocation.MyCommand.Source, $args `
            | %{ $_ }
        ) `
        -Verb RunAs
    exit
}

#beginning
printOut("This script will attempt to fix the gates.");
pause

#Part 1
printOut("Part 1 - kill the software");
Stop-Process -Name "Sentinel"
echo "Finished 1"

#part 2
printOut("Part 2 - Disable the usb device");
echo "Get device"
$d = Get-PnpDevice -FriendlyName "Sentinel Systems USB CIM (*"
echo "Disable device"
$d | Disable-PnpDevice -Confirm:$false
echo "Finished part 2"
Clear-Variable d

#part 3
printOut("Part 3 - Disable the driver");
echo "Get device"
$d = Get-PnpDevice -FriendlyName "Sentinel Systems USB CIM"
echo "Disable device"
$d | Disable-PnpDevice -Confirm:$false
echo "Finished part 3"
Clear-Variable d

#part 4
printOut("Part 4 - update the driver");
pnputil /add-driver C:\Winsen\FTDI_Unified\*
echo "Finished Part 4"

#part 5
printOut("part 5 - Enable the driver");
$d = Get-PnpDevice -FriendlyName "Sentinel Systems USB CIM"
$d  | Enable-PnpDevice -Confirm:$false
echo "Device Enabled"
Clear-Variable d
echo "Finished Part 5"

#part 6
printOut("part 6 - Enable the driver");
$d = Get-PnpDevice -FriendlyName "Sentinel Systems USB CIM (*"
$d  | Enable-PnpDevice -Confirm:$false
echo "Device Enabled"
Clear-Variable d
echo "Finished Part 6"

#Part 7
printOut("Part 7 - Restart the software");
start C:\Winsen\Sentinel.exe
echo "Finished Part 7"


echo ""
echo "Finished all tasks"
printOut("done");
Pause
