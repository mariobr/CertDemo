# Script to register/trust the self-signed certificate
# This script must be run as Administrator

# Write-Host "use 1_installcert.ps1..." -ForegroundColor Cyan
# Break


$certKeyPath = ".\selfsigned.acc-licensing.eu.cer"
$certName = "selfsigned-demo"

Write-Host "Installing certificate to Trusted Root Certification Authorities..." -ForegroundColor Green

# Import certificate to Trusted Root store (requires admin privileges)
try {
    $passwd = ConvertTo-SecureString -String "certtest" -Force -AsPlainText 
    # $rootCert = $(Import-PfxCertificate -FilePath $certKeyPath -CertStoreLocation 'Cert:\LocalMachine\Root' -Password $passwd)
    $rootCert = $(Import-Certificate -FilePath $certKeyPath -CertStoreLocation 'Cert:\LocalMachine\Root')

    # Verify installation
    $thecert = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object { $_.Subject -like "*$certName*" }
    if ($thecert) {
        Write-Host "✓ Certificate verified in Trusted Root store" -ForegroundColor Green
        Write-Host "Subject: $($thecert.Subject)" -ForegroundColor Yellow
        Write-Host "Thumbprint: $($thecert.Thumbprint)" -ForegroundColor Yellow
        Write-Host "Valid From: $($thecert.NotBefore)" -ForegroundColor Yellow
        Write-Host "Valid To: $($thecert.NotAfter)" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "Error installing certificate: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure you're running this script as Administrator!" -ForegroundColor Yellow
}

# Optional: Add hosts entry for the domain
$hostsPath = "C:\Windows\System32\drivers\etc\hosts"
$domain = "selfsigned.acc-licensing.eu"
$entry = "127.0.0.1    $domain"

Write-Host "`nChecking hosts file..." -ForegroundColor Green
if (-not (Get-Content $hostsPath -ErrorAction SilentlyContinue | Select-String -Pattern $domain)) {
    try {
        Add-Content -Path $hostsPath -Value "`n$entry" -Force
        Write-Host "✓ Added hosts entry: $entry" -ForegroundColor Green
    } catch {
        Write-Host "Warning: Could not modify hosts file. You may need to run as Administrator." -ForegroundColor Yellow
        Write-Host "Manually add this line to C:\Windows\System32\drivers\etc\hosts:" -ForegroundColor Yellow
        Write-Host "$entry" -ForegroundColor Cyan
    }
} else {
    Write-Host "✓ Hosts entry already exists for $domain" -ForegroundColor Green
}

Write-Host "`nCertificate trust setup complete!" -ForegroundColor Green
Write-Host "You may need to restart your browser for changes to take effect." -ForegroundColor Yellow