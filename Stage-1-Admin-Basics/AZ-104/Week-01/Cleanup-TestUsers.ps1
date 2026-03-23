# Connect to your Azure Tenant
Connect-MgGraph -Scopes "User.ReadWrite.All"

# 2. Define your domain (Match this to your Create script)
$Domain = "yourtenant.onmicrosoft.com"

# 3. Delete the 10 Lab Users
1..10 | ForEach-Object {
    $UserNum = "{0:D2}" -f $_
    $UPN = "labuser$UserNum@$Domain"

    try {
        Write-Host "Removing User: $UPN..." -ForegroundColor Yellow
        Remove-MgUser -UserId $UPN
        Write-Host "Success!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to remove $UPN or user not found." -ForegroundColor Red
    }
}
