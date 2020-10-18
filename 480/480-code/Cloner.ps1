$filler = Read-Host -Prompt 'do you have a json file to fill in the blanks? Y or N'
    if ($filler -eq 'Y') {
        $file_name = Read-Host -Prompt 'what is the full name of the json file?'
        $myconfig = Get-Content -Raw -Path $file_name | ConvertFrom-Json
    
        $server = Connect-VIServer -Server $myconfig.server_name

        $folder = Get-Folder -Name $myconfig.folder_name
    
        $svmhost = Get-VMhost -Name $myconfig.vmhost_name

        $dstore = Get-Datastore -Name $myconfig.dstore_name

    } 

    else {
        #fConnect to Vcenter server
        $server_name = Read-Host -Prompt 'What is the Vcenter server you wish to connect?'
        $server = Connect-VIServer -Server $server_name 

        #Show folder if there is one
        $folder_name = Read-Host -Prompt 'What older do you wish to view?'
        $folder = Get-Folder -Name $folder_name
        Get-VM -Location $folder_name 

        #Selecting the VMhost
        Write-Host 'list of avalable VMHosts'
        $VMHosts = Get-VMHost
        foreach ($VMHost in $VMHosts){Write-Host $VMHost.name}
        $vmhost_name = Read-Host -Prompt 'what is the host you wish to use?'
        $svmhost = Get-VMhost -Name $vmhost_name
        Write-Host 'you picked' $vmhost_name

        #Selecting the correct datastore
        Write-Host 'list of avalable datastores'
        $datastores = Get-Datastore
        foreach ($datastore in $datastores){Write-Host $datastore.name} 
        $dstore_name = Read-Host -Prompt 'what is the datastore you wish to use?'
        $dstore = Get-Datastore -Name $dstore_name
        Write-Host 'you picked' $dstore_name
    }

#Selecting a basevm
Write-Host 'Here is a list of all VMs on this server'
Get-VM
$basevm_name = Read-Host -Prompt 'what is the name of the vm you want to clone?'
$basevm = Get-VM -Name $basevm_name
Write-Host 'you picked' $basevm_name

#Selecting a save location
$save_location = Read-Host -Prompt 'where do you want to save this clone'
Write-Host 'this clone will be saved to' $save_location

#Choseing a cloneing type, creating a name will be done after a clone type has been chosen
#all shared varables between the two types will be selected before makeing a clone type choice
$clone_type = Read-Host -Prompt 'do you want this to be a [L]inked-clone or a clone of the [C]urrent state of the VM?'
#Linked clone option will ask for a base screenshot before continuing on.
    if ($clone_type -eq 'L'){
        Write-Host 'list of avalable snapshots for the VM you chose'
        $snapshots = Get-Snapshot -VM $basevm_name
        foreach ($snapshot in $snapshots){Write-Host $snapshot.name}
        $snapshot_name = Read-Host -Prompt 'what is the snapshot you wish to select?'
        $ssnapshot = Get-Snapshot -VM $basevm_name -name $snapshot_name
        Write-Host 'you picked' $snapshot_name

        $clone_name = Read-Host -Prompt 'what do you want to call this linked clone? [please add (-linked) to the end of your name]'

        $newvm = New-VM -Name $clone_name -VM $basevm -LinkedClone -ReferenceSnapshot $ssnapshot -VMHost $svmhost -Datastore $dstore -Location $save_location
    }
    elseif ($clone_type -eq 'C' ){ 
        $clone_name = Read-Host -Prompt 'what do you want to call this clone?'

        $newvm = New-VM -Name $basevm -VMHost $svmhost -Datastore $dstore -Location $save_location
    }
    else {
        Write-Host 'that is not a valid option'
    }  