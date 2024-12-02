namespace aoc24;

public static class Input
{
    public const string InputPath = "../input.txt";
    public const string CookiePath = ".cookie.session";

    public static string FetchFromWeb()
    {
        var day = DateTime.Today.Day;
        var year = DateTime.Today.Year;

        return FetchFromWeb(year, day);
    }

    public static string FetchFromWeb(int year, int day)
    {
        var inputUrl = $"https://adventofcode.com/{year}/day/{day}/input";
        var cookie = File.ReadAllText(CookiePath);
        var inputFilePath = string.Format(InputPath, day);

        Console.WriteLine(inputFilePath);

        using var httpClient = new HttpClient();
        httpClient.DefaultRequestHeaders.Add("Cookie", $"session={cookie}");

        var response = httpClient.GetAsync(inputUrl).Result;
        response.EnsureSuccessStatusCode();

        return response.Content.ReadAsStringAsync().Result;
    }
}
