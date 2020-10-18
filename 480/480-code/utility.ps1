$server_name = Read-Host -Prompt 'What is the Vcenter server you wish to connect?'
$server = Connect-VIServer -Server $server_name

function setNetwork {

    Write-Host 'Here is a list of all VMs on this server'
    Get-VM
    $vm_name = Read-Host -Prompt 'what is the name of the vm you want?'
    $vm = Get-VM -Name $vm_name
    Write-Host 'you picked' $vm_name

    Write-Host 'Here is a list of all interfaces on this vm'
    $interfaces = $vm | Get-NetworkAdapter
    $number = Read-Host -Prompt 'which inferface do you want to edit? (type (#) starting at 0'
    $netname = Read-Host -Prompt 'what interface do you want to set to?'
    $interfaces[$number] | Set-NetworkAdapter -NetworkName $netname    
}

function getIP {

    Write-Host 'Here is a list of all VMs on this server'
    Get-VM
    $vm_name = Read-Host -Prompt 'what is the name of the vm you want?'
    $vm = Get-VM -Name $vm_name
    
    Write-Host $ips = $vm.Guest.IPAddress[0] hostname=$vm.name
}


Write-Host 'Would you like to..'
Write-Host '[A] change network interface'
Write-Host '[B] get a ip address of a turned on VM'

$option = Read-Host -Prompt 'what would you like to do? enter the letter of the funtion you wish to preform'

if ($option -eq 'A') {
    setNetwork
}
elseif ($option -eq 'B') {
    getIP    
}
else {
    Write-Host 'that is not a vaild option'
}