<# Each user has
    First Name
    Last Name   
    Password 
    Groups  
    Email  
    UserId    #>


if ($Args[0] -is [int]){
    $NUMBER_OF_USERS = $Args[0];
    $NUMBER_OF_COMPUTERS = [math]::Ceiling($NUMBER_OF_USERS / 10);
} else {
    Write-Output "Invalid Input for Users defaulting to default Value [100]";
    $NUMBER_OF_USERS = 100
    $NUMBER_OF_COMPUTERS = [math]::Ceiling($NUMBER_OF_USERS / 10);
}

$GROUPS_LIST = Get-Content .\data\Groups.txt
$FIRST_NAMES_LIST = Get-Content .\data\FirstNames.txt
$LAST_NAMES_LIST = Get-Content .\data\LastNames.txt
$PASSWORDS = [System.Collections.ArrayList](Get-Content .\Data\passwords.txt);

function genUsers{
    $UsersArray = @();

    [System.Collections.ArrayList]$Users = $UsersArray;
    #Write-Output $NUMBER_OF_USERS;
    for($num = 1; $num -le $NUMBER_OF_USERS; $num++){
        $User = createUser;
        [void]$Users.Add($User);
    }

    $UsersJson = ConvertTo-Json $Users ;
    
    Set-Content -Path  ".\user_answers.json" -Value $UsersJson;
}

function createUser{
    $NumberOfGroups = Get-Random -Minimum 1 -Maximum 3
    $UserGroups = $GROUPS_LIST | Get-Random -Count $NumberOfGroups;
    $FirstName = $FIRST_NAMES_LIST | Get-Random;
    $LastName = $LAST_NAMES_LIST | Get-Random;
    $UserNum = Get-Random -Minimum 0 -Maximum 1000;
    $UserId = $FirstName[0] + $LastName + $UserNum;
    $UserEmail = $UserId +"@vm.com";
    $Password = $PASSWORDS | Get-Random;
    $PASSWORDS.Remove($Password);
<#     $randWeakPassChance = Get-Random -Minimum 0 -Maximum 100
    if ($randWeakPassChance -le 5){
        $Password = 123456
    } #>
    $User = @{
        FirstName = $FirstName
        LastName = $LastName
        UserId = $UserId
        Email = $UserEmail
        Password = $Password
        Groups = $UserGroups
    }

    return $User;
}

function genComputers{
    $ComputersArray = @();

    [System.Collections.ArrayList]$Computers = $ComputersArray;

    for($num = 1; $num -le $NUMBER_OF_COMPUTERS; $num++){
        $PCName = "WE Computer "+$num
        $Computer = @{
            Name = $PCName
            SamAccountName = $PCName
            Enabled = $True
        }

        [void]$Computers.Add($Computer);
    }
    $ComputersJson = ConvertTo-Json $Computers ;
    
    Set-Content -Path  ".\computers_anwsers.json" -Value $ComputersJson;
}

function getUsernames{
    Clear-Content -Path .\Data\usernames.txt;
    $Users = Get-Content .\user_answers.json | ConvertFrom-Json;
    foreach($user in $Users){
        #Write-Output $user;
        Add-Content -Path .\Data\usernames.txt -Value $user.UserId
    }

}

genUsers;
genComputers;
getUsernames;