# Block of variables to get admin credentials and new user info.
$adminCredential = Get-Credential
$firstName = Read-Host -Prompt "Enter user's first name"
$lastName = Read-Host -Prompt "Enter user's last name"
$userName = $firstName.Substring(0,1)+$lastName
$userName = $userName.ToLower()
$userEmail = $userName+"@elford.com"
$userPassword = Read-Host -Prompt "Enter the password for this user"

# Block of variables to setup groups of various departments.
$accountingGroups = @("Accounting Dept", "Accounting Minutes", "Accounting Staff", "All", "All Office", "MapG", "usr_ElfordIncStaff", "VPNUsers")
$estimatingGroups = @("All", "All Office", "usr_ElfordIncStaff", "MapG", "Estimating", "Estimating Minutes", "Estimating Staff", "newproposals", "TimberlineUsers", "usr_ESTPRECON_EMP", "MapI", "VPNUsers", "iPad Project Management Staff", "iPhone Project Management Staff")
$opsAPMGroups = @("All", "All Office", "APMs", "iPad Project Management Staff", "iPhone Project Management Staff", "MapG", "usr_ElfordIncStaff", "VPNUsers")
$opsPMGroups = @("All", "All Office", "DocsPM", "iPad Project Management Staff", "iPhone Project Management Staff", "MapG", "MapI", "PMs", "usr_ElfordIncStaff", "Visa", "VPNUsers")
$spdAPMGroups = @("All", "All Office", "MapG", "Service Staff", "usr_ElfordIncStaff", "iPad Project Management Staff", "iPhone Project Management Staff", "VPNUsers")
$spdPMGroups = @("All", "All Office", "MapG", "MapI", "Visa", "Service Staff", "usr_ElfordIncStaff", "iPad Project Management Staff", "iPhone Project Management Staff", "VPNUsers")
$spdEstimatingGroups = @("All", "All Office", "MapG", "Estimating", "iPad Project Management Staff", "iPhone Project Management Staff", "MapG", "newproposals", "Service Minutes", "TimberlineUsers", "usr_ElfordIncStaff", "usr_ESTPRECON_SPD", "VPNUsers")
$hrGroups = @("All", "All Office", "CNGGroup", "HR", "MapG", "MapH", "MapI", "Onboarding", "VPNUsers", "usr_ElfordIncStaff")
$marketingGroups = @("All", "All Office", "MapG", "MapM", "Marketing Meeting Minutes", "Marketing Staff", "usr_ElfordIncStaff")
$superintendentGroups = @("All", "CMiC Mobile Field Prod", "iPad Field Staff", "iPhone Project Management Staff", "Superintendents", "usr_ElfordIncStaff", "Visa")

# Setup of the user config info to be passed to AD for user creation.
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

# New-ADUser @userConfig`
$userDepartment = Read-Host -Prompt "What department is the user in? Input the corresponding number.`n 1. Accounting`n 2. Estimating`n 3. HR`n 4. Ops`n 5. SPD`n 6. Marketing`n 7. Superintendent"

# Switch statement to select dept/role for group allocation of new user
Switch($userDepartment){
    1 { ForEach ($Group in $accountingGroups) {
            Add-ADPrincipalGroupMembership -Identity $userName -MemberOf $Group
            }
        break;
        }

    2 { ForEach ($Group in $esti