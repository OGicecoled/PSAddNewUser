$adminCredential = Get-Credential
$firstName = Read-Host -Prompt "Enter user's first name"
$lastName = Read-Host -Prompt "Enter user's last name"
$userName = $firstName.Substring(0,1)+$lastName
$userName = $userName.ToLower()
$userEmail = $userName+"@elford.com"
$userPassword = Read-Host -Prompt "Enter the password for this user"

$accountingGroups = @("Accounting Dept", "Accounting Minutes", "Accounting Staff", "All", "All Office", "MapG", "usr_ElfordIncStaff", "VPNUsers")
$opsGroups = 

$userConfig = @{
    Name = "$firstName $lastName"
    AccountPassword = "$userPassword"
    SAMAccountName = "$userName"
    DisplayName = "$firstName $lastName"
    EmailAddress = "$userEmail"
    Enabled = $true
    GivenName = "$firstName"
    Surname = "$lastName"
    UserPrincipalName = "$userEmail"
    }

#New-ADUser @userConfig`
$userDepartment = Read-Host -Prompt "What department is the user in? Input the corresponding number.`n 1. Accounting`n 2. Estimating`n 3. HR`n 4. Ops`n 5. SPD`n 6. Marketing"

Switch($userDepartment){
    1 { ForEach ($Group in $accountingGroups) {
            Add-ADPrincipalGroupMembership -Identity $userName -MemberOf $Group
            }
        break;
        }
