#=====================================================================================================================================
#
# NAME: Restore Recovering mode databases
#
# AUTHOR: Florent APPOINTAIRE
# DATE: 06/06/2017
# VERSION: 1.0
#
# COMMENT: The purpose of this script is to restore your database when it's stuck in "Restoring", from Azure Blob Storage
# USING : .\Restore_RecoveryMode_DB_v1.0.ps1 
#
#=====================================================================================================================================

#Import the SQL Powershell Module
Import-Module SQLPS

#Provide value where the Backup is located
$containerBackup = "URL To Your Backup"
$serverInstance = "FLOAPP-SQL01\SC"
$stoName = "StorageWhereBackupIsLocated"
$rgName = "Storage"
$keySto = "storageaccountkey"
$containerName = "Container Name"

#Get all databases that are currently in restoring mode
$databases = Get-SqlDatabase -ServerInstance $serverInstance | Where {$_.Status -eq "Restoring"}

#For each DB in restoring, we will restore the last backup
foreach ($db in $databases){

    $dbName = $db.Name
    Write-Host -ForegroundColor Green "Restore DB $dbName"

	#Connecting to the Azure Blog Storage
    $ctx = New-AzureStorageContext -StorageAccountKey $keySto -StorageAccountName $stoName
    $bckItems = Get-AzureStorageBlob -Container $containerName -Context $ctx

    foreach ($bckItem in $bckItems){
    
        if ($bckItem.Name -like "*$dbName-*"){
    
            $bckName = $bckItem.Name
            Restore-SqlDatabase -ServerInstance $serverInstance -Database $dbName -BackupFile $containerBackup/$bckName
    
        }
    
    }
}