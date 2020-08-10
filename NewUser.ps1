# Block of variables to get admin credentials and new user info.
$adminCredential = Get-Credential
$firstName = Read-Host -Prompt "Enter user's first name"
$lastName = Read-Host -Prompt "Enter user's last name"
$userName = $firstName.Substring(0,1)+$lastName
$userName = $userName.ToLower()
$userEmail = $userName+"@elford.com"
$userPassword = Read-Host -AsSecureString -Prompt "Enter the password for this user"
$passwordCheck = Read-Host -AsSecureString -Prompt "Re-enter the password for this user"
$userDepartment = 0

# Check to make sure passwords are the same
$userPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($userPassword))
$passwordCheckText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordCheck))

If ($userPasswordText -cne $passwordCheckText) {
    Do {
        Write-Output "Passwords don't match."

        $userPassword = Read-Host -AsSecureString -Prompt "Enter the password for this user"
        $passwordCheck = Read-Host -AsSecureString -Prompt "Re-enter the password for this user"

        $userPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($userPassword))
        $passowrdCheckText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordCheck))

    } While($userPasswordText -cne $passowrdCheckText)
}
Else {
    Write-Output "Passwords match"
    }


# Block of variables to setup groups of various departments.
$accountingGroups = @("Accounting Dept", "Accounting Minutes", "Accounting Staff", "All", "All Office", "MapG", "usr_ElfordIncStaff", "VPNUsers")
$estimatingGroups = @("All", "All Office", "usr_ElfordIncStaff", "MapG", "Estimating", "Estimating Minutes", "Estimating Staff", "newproposals", "TimberlineUsers", "usr_ESTPRECON_EMP", "MapI", "VPNUsers", "iPad Project Management Staff", "iPhone Project Management Staff")
$opsAPMGroups = @("All", "All Office", "APMs", "iPad Project Management Staff", "iPhone Project Management Staff", "MapG", "usr_ElfordIncStaff", "VPNUsers")
$opsPMGroups = @("All", "All Office", "DocsPM", "iPad Project Management Staff", "iPhone Project Management Staff", "MapG", "MapI", "PMs", "usr_ElfordIncStaff", "Visa", "VPNUsers")
$spdAPMGroups = @("All", "All Office", "MapG", "Service Staff", "usr_ElfordIncStaff", "iPad Project Management Staff", "iPhone Project Management Staff", "VPNUsers")
$spdPMGroups = @("All", "All Office", "MapG", "MapI", "Visa", "Service Staff", "usr_ElfordIncStaff", "iPad Project Management Staff", "iPhone Project Management Staff", "VPNUsers")
$spdEstimatingGroups = @("All", "All Office", "MapG", "Estimating", "iPad Project Management Staff", "iPhone Project Management Staff", "MapG", "newproposals", "Service Minutes", "TimberlineUsers", "usr_ElfordIncStaff", "usr_ESTPRECON_SPD", "VPNUsers")
$hrGroups = @("All", "All Office", "CNGGroup", "HR", "MapG", "MapH", "MapI", "Onboarding", "VPNUsers", "usr_ElfordIncStaff", "iPhone Project Management Staff")
$marketingGroups = @("All", "All Office", "MapG", "MapM", "Marketing Meeting Minutes", "Marketing Staff", "usr_ElfordIncStaff")
$superintendentGroups = @("All", "CMiC Mobile Field Prod", "iPad Field Staff", "iPhone Project Management Staff", "Superintendents", "usr_ElfordIncStaff", "Visa")

# Setup of the user config info to be passed to AD for user creation.
$userConfig = @{
    Name = "$firstName $lastName"
    AccountPassword = $userPassword
    SAMAccountName = "$userName"
    DisplayName = "$firstName $lastName"
    EmailAddress = "$userEmail"
    Enabled = $true
    GivenName = "$firstName"
    PassThru = $true
    Surname = "$lastName"
    UserPrincipalName = "$userEmail"
    }

New-ADUser -Credential $adminCredential  @userConfig -Path "OU=Elforddotcom, OU=Users, OU=Accounts, DC=elford,DC=com"

Do {
$userDepartment = Read-Host -Prompt "What department is the user in? Input the corresponding number.`n 1. Accounting`n 2. Estimating`n 3. HR`n 4. Ops`n 5. SPD`n 6. Marketing`n 7. Superintendent`n"

    If ($userDepartment -lt 1 -or $userDepartment -gt 7) {
        Write-Output "Incorrect input"
        }
    } While ($userDepartment -lt 1 -or $userDepartment -gt 7)

# Switch statement to select dept/role for group allocation of new user
Switch($userDepartment){
    1 { ForEach ($Group in $accountingGroups) {
            Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
            }
        break;
        }

    2 { $estimatingChoice = Read-Host -Prompt "Is the user an estimator in SPD? Y/N"
            If ($estimatingChoice.ToLower() -eq "y") {
                ForEach ($Group in $spdEstimatingGroups) {
                    Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                    }
                        }
            Else {
                ForEach ($Group in $estimatingGroups) {
                    Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                    }
                        }
        break;
                            }

    3 { ForEach ($Group in $hrGroups) {
            Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
            }
        break;
        }

    4 { $opsChoice = Read-Host -Prompt "Is this user a 1. PM or 2. APM?"
            If ($opsChoice -eq 1) {
                ForEach ($Group in $opsPMGroups) {
                    Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                    }
                        }
            ElseIf ($opsChoice -eq 2) {
                ForEach ($Group in $opsAPMGroups) {
                    Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                    }
                        }
            Else {
                Do {
                Write-Output "Incorrect choice"
                $opsChoice = Read-Host -Prompt "Is this user a 1. PM or 2. APM?"

                If ($opsChoice -eq 1) {
                ForEach ($Group in $opsPMGroups) {
                    Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                    }
                        }
            ElseIf ($spdChoice -eq 2) {
                ForEach ($Group in $opsAPMGroups) {
                    Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                    }
                        }
                    } While ($spdChoice -ne 1 -or $spdChoice -ne 2)
                }
        break;
        }

        5 { $spdChoice = Read-Host -Prompt "Is this user a 1. PM or 2. APM?"
            If ($spdChoice -eq 1) {
                ForEach ($Group in $spdPMGroups) {
                    Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                    }
                        }
            ElseIf ($spdChoice -eq 2) {
                ForEach ($Group in $spdAPMGroups) {
                    Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                    }
                        }
            Else {
                Do {
                Write-Output "Incorrect choice"
                $spdChoice = Read-Host -Prompt "Is this user a 1. PM or 2. APM?"

                If ($spdChoice -eq 1) {
                ForEach ($Group in $spdPMGroups) {
                    Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                    }
                        }
            ElseIf ($spdChoice -eq 2) {
                ForEach ($Group in $spdAPMGroups) {
                    Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                    }
                        }
                    } While ($spdChoice -ne 1 -or $spdChoice -ne 2)
                }
        break;
        }

        6 {
            ForEach ($Group in $marketingGroups) {
                Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                }
        break;
                    }

        7 {
            ForEach ($Group in $superintendentGroups) {
                Add-ADPrincipalGroupMembership -Credential $adminCredential -Identity $userName -MemberOf $Group
                }
        break;
                    }
    }