# 1. Ensure Connection
$currentContext = Get-MgContext
if ($null -eq $currentContext) {
    Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"
}

# 2. Corrected Domain (The native tenant domain)
$Domain = "markygallenerogmail.onmicrosoft.com"
$PasswordProfile = @{ Password = "ComplexPassword123!" }

# 3. Create 10 Test Users
1..10 | ForEach-Object {
    $UserNum = "{0:D2}" -f $_
    $Parameters = @{
        DisplayName       = "Lab-User-$UserNum"
        UserPrincipalName = "labuser$UserNum@$Domain"
        MailNickname      = "labuser$UserNum"
        UsageLocation     = "PH"
        PasswordProfile   = $PasswordProfile
        AccountEnabled    = $true
    }

    Write-Host "Creating User: Lab-User-$UserNum..." -ForegroundColor Cyan
    try {
        New-MgUser @Parameters
    } catch {
        Write-Host "Failed to create Lab-User-$UserNum. Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}