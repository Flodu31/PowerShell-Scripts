#=====================================================================================================================================
#
# NAME: Backup Databases to Azure
#
# AUTHOR: Florent APPOINTAIRE
# DATE: 06/06/2017
# VERSION: 1.0
#
# COMMENT: The purpose of this script is to backup your SQL Server databases to an Azure Blob Storage
# USING : .\Backup_DB_To_Azure_v1.0.ps1 
#
#=====================================================================================================================================

#Import the SQL Powershell Module
Import-Module SQLPS

#Provide value where the Backup will be stored and the SQL Server and instance
$containerBackup = "URL to Backup"
$serverInstance = "Instances where DB are located"

$databases = Get-SqlDatabase -ServerInstance $serverInstance

foreach ($db in $databases){

    $dbName = $db.Name
    Write-Host -ForegroundColor Green "Backing up database $dbName"
    
    #Backup the selected database to Azure
    Backup-SqlDatabase -ServerInstance $serverInstance -BackupContainer $containerBackup -Database $dbName

}