Import-Module ActiveDirectory

$GROUPS_LIST = Get-Content .\data\Groups.txt

$Users = Get-Content .\user_answers.json | ConvertFrom-Json;
$Computers = Get-Content .\computers_anwsers.json | ConvertFrom-Json;

if ($Args[0] -eq "cleanup"){
    Remove-ADOrganizationalUnit -Identity "OU=WE,DC=vm,DC=COM" -Recursive 
}elseif($Args[0] -eq "help"){
    Write-Output "cleanup to clean the directory before adding the users"
}

function setUpOUs{
    New-ADOrganizationalUnit -Name "WE" -Path "DC=vm,DC=COM" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name "WE Computers" -Path "OU=WE,DC=vm,DC=COM" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name "WE Users" -Path "OU=WE,DC=vm,DC=COM" -ProtectedFromAccidentalDeletion $False 
    New-ADOrganizationalUnit -Name "WE Groups" -Path "OU=WE,DC=vm,DC=COM" -ProtectedFromAccidentalDeletion $False
    New-ADOrganizationalUnit -Name "WE Servers" -Path "OU=WE,DC=vm,DC=COM" -ProtectedFromAccidentalDeletion $False 
}

function addADUsers{
    ForEach ($user in $Users){
        New-ADUser `
            -Name $user.UserId `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -DisplayName $user.UserId `
            -UserPrincipalName $user.UserId `
            -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
            -Description $user.Description `
            -EmailAddress $user.Email `
            -Path "OU=WE Users,OU=WE,DC=vm,DC=COM" `
            -Enabled $True 
        
        # $id = $user.UserId
        #$userG = Get-ADUser -Filter "UserPrincipalName -eq '$id'" -SearchBase "OU=WE Users,OU=WE,DC=vm,DC=COM";

<#         ForEach($group in $user.Groups){
            Write-Output $group;
            Add-ADGroupMember -Identity $group -Members $userG
        }  #>
    }
}
#New-ADGroup -Name "RODC Admins" -SamAccountName RODCAdmins -GroupCategory Security -GroupScope Global -DisplayName "RODC Administrators" -Path "CN=Users,DC=Fabrikam,DC=Com" -Description "Members of this group are RODC Administrators"
function addADGroups{
    ForEach ($group in $GROUPS_LIST){
        New-ADGroup `
            -Name $group `
            -GroupCategory 1 `
            -GroupScope 1 `
            -DisplayName $group `
            -Path "OU=WE Groups,OU=WE,DC=vm,DC=COM" `
            -Description "Added by an automated Script" `
        #1 == Security
        #1 == Global
    }
}

function addADComputers{
    ForEach($Computer in $Computers){
        New-ADComputer `
        -Name $Computer.Name `
        -SamAccountName $Computer.SamAccountName `
        -Path "OU=WE Computers,OU=WE,DC=vm,DC=COM" `
        -Enabled $True
    }
}

setUpOUs;
addADGroups;
addADUsers; 
addADComputers;
