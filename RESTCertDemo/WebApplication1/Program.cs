using System.Runtime.InteropServices;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using WebApplication1;

Console.WriteLine("Demo Certs public");

var builder = WebApplication.CreateBuilder(args);


if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
{
    builder.WebHost.ConfigureKestrel(options =>
    {
        string? secretValue = builder.Configuration.GetValue<string>("KestrelCertificatePassword");
        var certificateFilePath = "d:\\certs\\selfsigned.acc-licensing.eu.cer.pfx";

        options.ListenAnyIP(443, listenOptions =>
        {
            listenOptions.UseHttps("selfsigned.acc-licensing.eu.cer.pfx", secretValue);
        });
    });
}


builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

//app.UseHttpsRedirection();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();

app.MapControllers();

app.Run();
