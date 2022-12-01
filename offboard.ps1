
function get_user_objectid($offboard_upn) {
    $user_objectid = (Get-AzureADUser -Filter "UserPrincipalName eq '$offboard_upn'").ObjectId
    # Get the user's object ID

    if ($user_objectid -eq $null) {
        Write-Host "User not found. Please check the UPN and try again." -ForegroundColor Red
        exit
    }
    else {
        Write-Host "User found. Object ID is $user_objectid" -ForegroundColor Green
    }
    return $user_objectid
}

function get_user_groups($user_objectid) {
    $user_groups = (Get-AzureADUser -ObjectId $user_objectid).MemberOf
    # Get the user's groups

    if ($user_groups -eq $null) {
        Write-Host "User is not a member of any groups." -ForegroundColor Red
    }
    else {
        Write-Host "User is a member of the following groups:" -ForegroundColor Green
        $user_groups | Select DisplayName
    }
}

function remove_user_from_groups($user_objectid) {
    $user_groups = (Get-AzureADUser -ObjectId $user_objectid).MemberOf
    # Get the user's groups

    if ($user_groups -eq $null) {
        Write-Host "User is not a member of any groups." -ForegroundColor Green
    }
    else {
        Write-Host "Removing user from groups..." -ForegroundColor Green
        $user_groups | Remove-AzureADGroupMember -ObjectId $user_objectid
    }
}

function remove_user {
    Write-Host "Removing user..." -ForegroundColor Green
    Remove-AzureADUser -ObjectId $user_objectid
}



function email_action {
    Write-Host "1: Convert to shared inbox?" -ForegroundColor Green
    Write-Host "2: Forward email to another user?" -ForegroundColor Green
    Write-Host "3: Delete email?" -ForegroundColor Green
    Write-Host "4: Leave email in place?" -ForegroundColor Green
    $email_action = Read-Host "Please enter your choice"
    # Get the user's email action

    if ($email_action -eq "1") {
        Write-Host "Converting email to shared inbox..." -ForegroundColor Green
        # Convert email to shared inbox

    }
    elseif ($email_action -eq "2") {
        Write-Host "Forwarding email to another user..." -ForegroundColor Green
        # Forward email to another user
        $forward_email = Read-Host "Please enter the email address to forward to"
        # Get the user's email address to forward to


    }
    elseif ($email_action -eq "3") {
        Write-Host "Deleting email..." -ForegroundColor Green
        # Delete email
    }
    elseif ($email_action -eq "4") {
        Write-Host "Leaving email in place..." -ForegroundColor Green
        # Leave email in place
    }
    else {
        Write-Host "Invalid choice. Please try again." -ForegroundColor Red
        email_action
    }
}

function get_user_email($user_objectid) {
    $user_email = (Get-AzureADUser -ObjectId $user_objectid).Mail
    # Get the user's email address

    if ($user_email -eq $null) {
        Write-Host "User does not have an email address." -ForegroundColor Green
    }
    else {
        Write-Host "User has the following email address:" -ForegroundColor Green
        Write-Host $user_email -ForegroundColor Blue
        Write-Host "What would you like to do with the email?" -ForegroundColor Green
        email_action
    }
}
function menu {
   
    Write-Host "Please enter the UPN (user principal name) of the user you want to offboard:" -ForegroundColor Green
    $offboard_upn = Read-Host

    $user_objectid = get_user_objectid($offboard_upn)
    get_user_email($user_objectid)
    get_user_groups($user_objectid)
    }

    

#Connect to Azure AD
Connect-AzureAD
#Call the menu function
menu

