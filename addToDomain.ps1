Import-Module ActiveDirectory

$UsersJson = Get-Content .\user_answers.json;
$Users = ConvertFrom-Json -InputObject $UsersJson;
Write-Output $Users;