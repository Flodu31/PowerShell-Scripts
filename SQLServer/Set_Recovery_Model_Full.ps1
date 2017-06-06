#=====================================================================================================================================
#
# NAME: Change Recovery Model
#
# AUTHOR: Florent APPOINTAIRE
# DATE: 06/06/2017
# VERSION: 1.0
#
# COMMENT: The purpose of this script is to change the recovery model for all databases to full or simple
# USING : .\Set_Recovery_Model_v1.0.ps1 
#
#=====================================================================================================================================

#Provide the name of your SQL Server with the instance
$Server = "FLOAPP-SQL01\SC"
$recoveryModel = "Full"

switch (Full){

	#Change the recovery model to Full
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
	$SMOserver = New-Object ('Microsoft.SqlServer.Management.Smo.Server') -argumentlist $Server
	$SMOserver.Databases | where {$_.IsSystemObject -eq $false} | select Name, RecoveryModel | Format-Table
	$SMOserver.Databases | where {$_.IsSystemObject -eq $false} | foreach {$_.RecoveryModel = [Microsoft.SqlServer.Management.Smo.RecoveryModel]::Full; $_.Alter()}
	$SMOserver.Databases | where {$_.IsSystemObject -eq $false} | select Name, RecoveryModel | Format-Table

}      

