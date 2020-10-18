#Connect to Vcenter server
$server_name = Read-Host -Prompt 'What is the Vcenter server you wish to connect?'
$server = Connect-VIServer -Server $server_name
Write-Host 'Here is a list of all VMs on this server'
Get-VM

$switch_name =  Read-Host -Prompt 'what do you want to call your switch?'

#Selecting the VMhost
Write-Host 'list of avalable VMHosts'
$VMHosts = Get-VMHost
foreach ($VMHost in $VMHosts){Write-Host $VMHost.name}
$vmhost_name = Read-Host -Prompt 'what is the host you wish to use?'
$svmhost = Get-VMhost -Name $vmhost_name
Write-Host 'you picked' $vmhost_name

#creating a virtual switch
$vswitch = New-VirtualSwitch -VMHost $svmhost -Name $switch_name -ErrorAction Ignore

$VPG = New-VirtualPortGroup -VirtualSwitch $vswitch -Name $switch_name

