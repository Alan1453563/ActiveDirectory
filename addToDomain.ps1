Import-Module ActiveDirectory

$Users = Get-Content .\user_answers.json | ConvertFrom-Json;
Write-Output Get-ADDomain;

function setUpOUs{
    New-ADOrganizationalUnit -Name "willarsEngineering" -Path "DC=vm,DC=COM" -ProtectedFromAccidentalDeletion $False
}

function addADUsers{
    ForEach ($user in $Users){
        New-ADUser `
            -
    }
}

function addADGroups{

}

function cleanUpAD{

}

setUpOUs;