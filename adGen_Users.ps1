<# Each user has
    First Name
    Last Name   
    Password 
    Groups  
    Email  
    UserId    #>


if ($Args[0] -is [int]){
    $NUMBER_OF_USERS = $Args[0];
} else {
    Write-Output "Invalid Input for Users defaulting to default Value";
    $NUMBER_OF_USERS = 1

}

$GROUPS_LIST = Get-Content .\data\Groups.txt
$FIRST_NAMES_LIST = Get-Content .\data\FirstNames.txt
$LAST_NAMES_LIST = Get-Content .\data\LastNames.txt


function genUsers{
    $UsersArray = @();

    [System.Collections.ArrayList]$Users = $UsersArray;
    #Write-Output $NUMBER_OF_USERS;
    for($num = 1; $num -le $NUMBER_OF_USERS; $num++){
        $User = createUser;
        [void]$Users.Add($User);
    }

    return $Users;
}

function createUser{
    $NumberOfGroups = Get-Random -Minimum 1 -Maximum 5
    $UserGroups = $GROUPS_LIST | Get-Random -Count $NumberOfGroups;
    $FirstName = $FIRST_NAMES_LIST | Get-Random;
    $LastName = $LAST_NAMES_LIST | Get-Random;
    $UserNum = Get-Random -Minimum 0 -Maximum 1000;
    $UserId = $FirstName[0] + $LastName + $UserNum;
    $UserEmail = $UserId +"vm.com";
    $Password = -join ((33..126) | Get-Random -Count 8 | % {[char]$_})

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

$Users = genUsers;

$UsersJson = ConvertTo-Json $Users ;

Set-Content -Path  ".\user_answers.json" -Value $UsersJson;