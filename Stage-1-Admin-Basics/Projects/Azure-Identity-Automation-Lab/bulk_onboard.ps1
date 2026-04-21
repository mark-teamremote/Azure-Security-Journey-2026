# --- CONFIGURATION ---
$Domain = "contoso-lab.onmicrosoft.com"
$Password = "Str0ng!Passw0rd2026#Azure"

# --- USERS ---
$Users = @(
    @{Name="SG_Audit_User"; Title="Compliance Lead"};
    @{Name="NY_NetOps_Vendor"; Title="External Firewall Admin"};
    @{Name="HK_AppDev_Contractor"; Title="Python Developer"};
    @{Name="UK_Merger_Project"; Title="Integration Analyst"};
    @{Name="Global_Service_Acc"; Title="Legacy Automation"}
)

foreach ($U in $Users) {

    $UPN = "$($U.Name)@$Domain"
    $MailNick = ($U.Name -replace '[^a-zA-Z0-9]', '').ToLower()

    Write-Host "`nProcessing: $UPN" -ForegroundColor Cyan

    # =====================================================
    # ✅ STEP 1: IDEMPOTENCY CHECK
    # =====================================================
    $existing = Get-EntraUser -Filter "UserPrincipalName eq '$UPN'" -ErrorAction SilentlyContinue

    if ($existing) {
        Write-Host "SKIPPED: User already exists" -ForegroundColor Yellow
    }
    else {
        try {
            # =====================================================
            # ✅ STEP 2: CREATE USER (MINIMAL)
            # =====================================================
            $PassProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
            $PassProfile.Password = $Password
            $PassProfile.ForceChangePasswordNextLogin = $true

            New-EntraUser `
                -DisplayName $U.Name `
                -UserPrincipalName $UPN `
                -AccountEnabled $true `
                -MailNickname $MailNick `
                -PasswordProfile $PassProfile `
                -UsageLocation "PH" `
                -JobTitle $U.Title `
                -ErrorAction Stop

            Write-Host "CREATED: $UPN" -ForegroundColor Green
        }
        catch {
            Write-Host "ERROR during creation: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # =====================================================
    # ✅ STEP 3: POST-CONFIGURATION (SEPARATE)
    # =====================================================
    try {
        Update-EntraUser -UserId $UPN -JobTitle $U.Title -ErrorAction Stop
        Write-Host "UPDATED: Job title set" -ForegroundColor Green
    }
    catch {
        Write-Host "WARNING: Update failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }

    # =====================================================
    # ✅ STEP 4: VERIFICATION (VERY IMPORTANT)
    # =====================================================
    $verify = Get-EntraUser -Filter "UserPrincipalName eq '$UPN'" -ErrorAction SilentlyContinue

    if ($verify) {
        Write-Host "CONFIRMED: User exists in Entra ID" -ForegroundColor Green
    }
    else {
        Write-Host "FAILED: User NOT found after operation" -ForegroundColor Red
    }
}
