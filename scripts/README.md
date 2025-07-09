# Requirement 4 asp.net

```powershell
dotnet user-secrets init --project "WebApplication1.csproj"
dotnet user-secrets set "KestrelCertificatePassword" "certtest" --project "WebApplication1.csproj"
```

+ <https://gist.github.com/malpou/e9f5faa9c1ce5dbf040029424ef85444>

## How to Trust a Self-Signed Certificate

### Prerequisites

+ Run PowerShell as Administrator for system-wide certificate installation
+ Ensure the certificate files exist in the scripts directory

### Method 1: Automated Script Installation (Recommended)

1. **Create the certificate** (if not already done):

   ```powershell
   .\1_installcert.ps1
   ```

2. **Trust the certificate** (Run as Administrator):

   ```powershell
   .\2_registercert.ps1
   ```

3. **Remove/Untrust when done** (Run as Administrator):

   ```powershell
   .\3_removecert.ps1
   ```

### Method 2: Manual Certificate Installation

1. **Import to Trusted Root Certification Authorities**:

   ```powershell
   # Import to system-wide trusted root store (requires admin)
   Import-Certificate -FilePath "selfsigned.acc-licensing.eu.cer" -CertStoreLocation Cert:\LocalMachine\Root
   
   # Import to user trusted root store
   Import-Certificate -FilePath "selfsigned.acc-licensing.eu.cer" -CertStoreLocation Cert:\CurrentUser\Root
   ```

2. **Add hosts entry** (if using a custom domain):

   ```powershell
   # Add to C:\Windows\System32\drivers\etc\hosts
   echo "127.0.0.1    selfsigned.acc-licensing.eu" >> C:\Windows\System32\drivers\etc\hosts
   ```

### Method 3: Browser-Specific Trust

**Chrome/Edge:**
1. Navigate to the HTTPS site
2. Click "Advanced" on the security warning
3. Click "Proceed to [domain] (unsafe)"
4. Or import the .cer file via browser settings

**Firefox:**
1. Navigate to the HTTPS site
2. Click "Advanced" → "Accept the Risk and Continue"
3. Or import via Settings → Privacy & Security → Certificates

### Method 4: Using Certificate Manager (certmgr.msc)

1. Open `certmgr.msc` as Administrator
2. Navigate to "Trusted Root Certification Authorities" → "Certificates"
3. Right-click → "All Tasks" → "Import"
4. Select your `selfsigned.acc-licensing.eu.cer` file
5. Complete the import wizard

### Verification

Check if certificate is trusted:
```powershell
# List certificates in trusted root store
Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object { $_.Subject -like "*selfsigned.acc-licensing.eu*" }

# Test with Invoke-WebRequest
Invoke-WebRequest -Uri "https://selfsigned.acc-licensing.eu:5001" -UseBasicParsing
```

### Important Notes

- **Security Warning**: Self-signed certificates bypass normal certificate validation. Only use for development/testing.
- **Administrator Rights**: Required for system-wide certificate installation
- **Browser Restart**: May be needed after certificate installation
- **Production**: Always use certificates from trusted Certificate Authorities in production

### Troubleshooting

- If browsers still show warnings, clear browser cache and restart
- Verify the certificate subject name matches the URL you're accessing
- Check that the certificate hasn't expired
- Ensure hosts file entry matches the certificate subject name
