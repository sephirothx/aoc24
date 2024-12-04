namespace aoc24;

public static class Input
{
    public const string InputPath = "{0}_{1}.txt";
    public const string CookiePath = ".cookie.session";

    public static string Get()
    {
        var day = DateTime.Today.Day;
        var year = DateTime.Today.Year;

        return Get(year, day);
    }

    public static string Get(int year, int day)
    {
        var filePath = string.Format(InputPath, year, day);

        if (!File.Exists(filePath))
        {
            File.WriteAllText(filePath, FetchFromWeb(year, day));
        }

        return File.ReadAllText(filePath);
    }

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

        using var httpClient = new HttpClient();
        httpClient.DefaultRequestHeaders.Add("Cookie", $"session={cookie}");

        var response = httpClient.GetAsync(inputUrl).Result;
        response.EnsureSuccessStatusCode();

        return response.Content.ReadAsStringAsync().Result.TrimEnd();
    }
}
