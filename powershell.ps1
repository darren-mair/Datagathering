#Start PS-Execution  
  
$Results = @()  
$Computer = Get-Content .\NetBIOS.txt  
  
#Run Command Concurrently for each machine in NetBIOS.txt list  
  
ForEach ($Computer in $Computer)  
{  
    $Properties = @{  
    NetBIOS_Name =  Get-WmiObject Win32_OperatingSystem -ComputerName $Computer | select -ExpandProperty CSName  
    OS_Name = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer | Select-Object -ExpandProperty Caption   
    OS_Architecture = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer | select -ExpandProperty OSArchitecture  
    System_Manufacturer = Get-WmiObject win32_computersystem -ComputerName $Computer | select -ExpandProperty Manufacturer  
    Model = Get-WmiObject win32_computersystem -ComputerName $Computer | select -ExpandProperty Model  
    CPU_Manufacturer = Get-WmiObject Win32_Processor -ComputerName $Computer | select -ExpandProperty Name  
    Disk_Size_GB = Get-WmiObject win32_diskDrive -ComputerName $Computer | Measure-Object -Property Size -Sum | % {[math]::round(($_.sum /1GB),2)}  
    Physical_Memory_GB = Get-WMIObject -class Win32_PhysicalMemory -ComputerName $Computer | Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1GB),2)} 
    Serial_Number = Get-WmiObject Win32_BIOS -ComputerName $Computer | Select -ExpandProperty SerialNumber 
    }  
 $Results += New-object psobject -Property $Properties  
} $Results | Select-Object NetBIOS_Name,OS_Name,OS_Architecture,System_Manufacturer,Model,CPU_Manufacturer,Disk_Size_GB,Physical_Memory_GB, Serial_Number | Export-csv -Path .\Machine_Inventory_$((Get-date).ToString('MM-dd-yyyy')).csv -NoTypeInformation 
