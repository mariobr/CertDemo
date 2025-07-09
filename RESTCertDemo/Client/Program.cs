// See https://aka.ms/new-console-template for more information
Console.WriteLine("Hello, Certs!");


var baseAddress = "https://selfsigned.acc-licensing.eu:443";

var httpclient = new HttpClient
{
    BaseAddress = new Uri(baseAddress),
    Timeout = TimeSpan.FromSeconds(3)
};


try
{
    var req = await httpclient.GetStringAsync($"{baseAddress}/WeatherForecast");

    Console.WriteLine(req);

    Console.WriteLine("Success");
}
catch (HttpRequestException e)
{
    Console.WriteLine($"Request error: {e.Message}");
    if (e.InnerException is not null)
    {
        Console.WriteLine($"Inner exception: {e.InnerException.Message}");
    }
}
catch (Exception e)
{
    Console.WriteLine($"An error occurred: {e.Message}");
}



Console.WriteLine("\r\r*** Finish +++\r");