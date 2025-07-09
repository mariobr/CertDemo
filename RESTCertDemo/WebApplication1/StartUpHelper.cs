using System.Security.Cryptography.X509Certificates;

namespace WebApplication1;

public class StartUpHelper
{
    public static X509Certificate2 GetHttpsCertificateFromStore()
    {
        using (var store = new X509Store(StoreName.My, StoreLocation.LocalMachine))
        {
            store.Open(OpenFlags.ReadOnly);
            var certCollection = store.Certificates;
            var currentCerts = certCollection.Find(X509FindType.FindBySubjectName, "selfsigned-demo", false);

            if (currentCerts.Count == 0)
            {
                throw new Exception("Https certificate is not found.");
            }

            return currentCerts[0];
        }
    }
}