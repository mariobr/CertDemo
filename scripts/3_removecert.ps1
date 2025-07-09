# Script to remove/untrust the self-signed certificate
# This script must be run as Administrator

$certName = "selfsigned.acc-licensing.eu"
$domain = "selfsigned.acc-licensing.eu"

Write-Host "Removing self-signed certificate from trust stores..." -ForegroundColor Yellow

# Remove from LocalMachine Root store
try {
    $rootCerts = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object { $_.Subject -like "*$certName*" }
    foreach ($cert in $rootCerts) {
        Remove-Item -Path "Cert:\LocalMachine\Root\$($cert.Thumbprint)" -Force
        Write-Host "✓ Removed certificate from LocalMachine Root store: $($cert.Thumbprint)" -ForegroundColor Green
    }
} catch {
    Write-Host "Error removing from LocalMachine Root: $($_.Exception.Message)" -ForegroundColor Red
}

# Remove from CurrentUser Root store
try {
    $userRootCerts = Get-ChildItem -Path Cert:\CurrentUser\Root | Where-Object { $_.Subject -like "*$certName*" }
    foreach ($cert in $userRootCerts) {
        Remove-Item -Path "Cert:\CurrentUser\Root\$($cert.Thumbprint)" -Force
        Write-Host "✓ Removed certificate from CurrentUser Root store: $($cert.Thumbprint)" -ForegroundColor Green
    }
} catch {
    Write-Host "Error removing from CurrentUser Root: $($_.Exception.Message)" -ForegroundColor Red
}

# Remove from Personal store (where it was originally created)
try {
    $personalCerts = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Subject -like "*$certName*" }
    foreach ($cert in $personalCerts) {
        Remove-Item -Path "Cert:\CurrentUser\My\$($cert.Thumbprint)" -Force
        Write-Host "✓ Removed certificate from Personal store: $($cert.Thumbprint)" -ForegroundColor Green
    }
} catch {
    Write-Host "Error removing from Personal store: $($_.Exception.Message)" -ForegroundColor Red
}

# Remove hosts entry
# $hostsPath = "C:\Windows\System32\drivers\etc\hosts"
# try {
#     $hostsContent = Get-Content $hostsPath -ErrorAction SilentlyContinue
#     $newContent = $hostsContent | Where-Object { $_ -notmatch $domain }
#     if ($hostsContent.Count -ne $newContent.Count) {
#         Set-Content -Path $hostsPath -Value $newContent -Force
#         Write-Host "✓ Removed hosts entry for $domain" -ForegroundColor Green
#     } else {
#         Write-Host "• No hosts entry found for $domain" -ForegroundColor Gray
#     }
# } catch {
#     Write-Host "Warning: Could not modify hosts file. You may need to run as Administrator." -ForegroundColor Yellow
# }

# Clean up certificate files (optional)
$certFiles = @("selfsigned.acc-licensing.eu.cer", "selfsigned.acc-licensing.eu.cer.pfx")
foreach ($file in $certFiles) {
    if (Test-Path $file) {
        try {
            Remove-Item $file -Force
            Write-Host "✓ Deleted certificate file: $file" -ForegroundColor Green
        } catch {
            Write-Host "Warning: Could not delete $file - $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
}

Write-Host "`nCertificate removal complete!" -ForegroundColor Green
Write-Host "You may need to restart your browser for changes to take effect." -ForegroundColor Yellow