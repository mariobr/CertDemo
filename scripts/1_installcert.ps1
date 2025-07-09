#$Certificate=New-SelfSignedCertificate -DnsName  "selfsigned.acc-licensing.eu" -CertStoreLocation "Cert:\CurrentUser\My"
$cert = New-SelfSignedCertificate -DnsName @("selfsigned.acc-licensing.eu")  -Subject "selfsigned-demo"  -CertStoreLocation "cert:\LocalMachine\My"

$certname = "selfsigned.acc-licensing.eu.cer"
$certPath = "..\RESTCertDemo\WebApplication1\"
$certKeyPath = "$certPath$certname.pfx"
Write-Host "Certificate path $certKeyPath" -ForegroundColor Green

$passwd = ConvertTo-SecureString -String "certtest" -Force -AsPlainText 
Export-PfxCertificate -Cert $cert -FilePath "$certKeyPath" -Password $passwd 
copy-item -Path $certKeyPath -Destination . -Force
Write-Host "Certificate created and exported successfully!" -ForegroundColor Green


$cert | Export-Certificate -Type cer -FilePath ".\$certname" -Force

# Import the certificate to the Local Machine Root store
$cert | Export-PfxCertificate -FilePath $certKeyPath -Password $passwd
# $rootCert = $(Import-PfxCertificate -FilePath $certKeyPath -CertStoreLocation 'Cert:\LocalMachine\Root' -Password $passwd)

#$CertLocation = "CurrentUser";
# $CertLocation = "LocalMachine";

# $dstStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root", $CertLocation)
# $dstStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
# $dstStore.Add($Certificate)
# $dstStore.Close()

# Set permissions on the MachineKeys directory 
# icacls C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys /inheritance:r /grant Administrators:F /grant:r Everyone:RW 