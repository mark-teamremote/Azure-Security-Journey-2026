# 1. Load the environment variables from your .env file
# The '.' at the start "dot-sources" the variables into this session
. ./Stage-1-Admin-Basics/Load-Env.ps1

# 2. Use the variables from memory ($env:Name)
$Domain   = $env:AZURE_PRIMARY_DOMAIN
$TenantId = $env:AZURE_TENANT_ID

# 3. Check and Connect to Microsoft Graph
$currentContext = Get-MgContext
if ($null -eq $currentContext -or $currentContext.TenantId -ne $TenantId) {
    Write-Host "Connecting to Tenant: $TenantId..." -ForegroundColor Yellow
    Connect-MgGraph -TenantId $TenantId -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"
} else {
    Write-Host "Already connected to: $($currentContext.Account)" -ForegroundColor Green
}

# 4. Define Password Profile (Keep this local to the script)
$PasswordProfile = @{ Password = "ComplexPassword123!" }

# 5. Create 10 Test Users
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
        # Check if user already exists first (Good Admin Practice)
        $ExistingUser = Get-MgUser -UserId $Parameters.UserPrincipalName -ErrorAction SilentlyContinue
        if ($null -eq $ExistingUser) {
            New-MgUser @Parameters
            Write-Host "Successfully created $UserNum" -ForegroundColor Green
        } else {
            Write-Host "User $UserNum already exists. Skipping..." -ForegroundColor Gray
        }
    } catch {
        Write-Host "Failed to create Lab-User-$UserNum. Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}