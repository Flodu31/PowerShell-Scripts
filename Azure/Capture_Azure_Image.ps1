#By executing this script, the VM will not be able to start anymore after the Sysprep

#Variables

$subscriptionName = "Visual Studio"
$ipName = "FLOAPP-IIS01PublicIP"
$location = "WestEurope"
$rgName = "Compute"
$newRG = "WebServers"
$vmName = "FLOAPP-IIS01"
$vnetRG = "Network"
$vnetName = "FLOAPP-VNet"
$subnetName = "subnet02"
$nsgName = "FLOAPP-IIS01-NSG"
$netInterface = "FLOAPP-IIS01NetInt"

#Login to Azure Account
Login-AzureRmAccount

#Select Azure subscription where the VM is located
Select-AzureRmSubscription -SubscriptionName $subscriptionName

#Do a sysprep of your VM with the following command line

cd sysprep
.\sysprep.exe /generalize /oobe /shutdown

#When the VM is syspreped, stop the VM with the following command
Stop-AzureRmVM -ResourceGroupName $rgName -Name $vmName

#Set the status to Generalized
Set-AzureRmVm -ResourceGroupName $rgName -Name $vmName -Generalized

#Get the status of the VM
$vm = Get-AzureRmVM -ResourceGroupName $rgName -Name $vmName -Status

#When the status is generalized, we can use the image 
foreach ($vm.Statuses){

    Write-Host $vm.Statuses.Code
    
    if ($vm.Statuses.Code -eq "OSState/generalized"){

    	Write-Host "VM $vmName is now generalized"

	}

}

#Create a new VM from the generalized VHD

#Create a new RG
New-AzureRmResourceGroup -Name $newRG -Location $location
#Get the VNet
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $vnetRG -Name $vnetName
#Get the subnet
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet
#Get the NSG
$nsg = Get-AzureRmNetworkSecurityGroup -Name $nsgName -ResourceGroupName $newRG
#Create a new public IP
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $newRG -Location $location -AllocationMethod Dynamic
#Create a new network interface
$nic = New-AzureRmNetworkInterface -Name $netInterface -ResourceGroupName $newRG -Location $location -PublicIpAddress $pip -Subnet $subnet -NetworkSecurityGroup $nsg

#Finish the script
New-AzureRmResourceGroupDeployment -Name tot -ResourceGroupName $rgName -TemplateFile -VMName webserveer -NetworkInterfaceID $nic.Id