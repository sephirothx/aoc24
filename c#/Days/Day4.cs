namespace aoc24.Days;

public static class Day4
{
    private static string[] ParseInput(string s)
    {
        return s.Split("\n");
    }

    public static int Part1(string s)
    {
        var sol = 0;
        var m = ParseInput(s);

        for (var i = 0; i < m.Length; i++)
        for (var j = 0; j < m.Length - 3; j++)
        {
            List<string> xmas =
            [
                new([m[i][j], m[i][j + 1], m[i][j + 2], m[i][j + 3]]),
                new([m[j][i], m[j + 1][i], m[j + 2][i], m[j + 3][i]]),
            ];

            if (i < m.Length - 3)
            {
                var jj = m.Length - j - 1;
                xmas.Add(new([m[i][j], m[i + 1][j + 1], m[i + 2][j + 2], m[i + 3][j + 3]]));
                xmas.Add(new([m[i][jj], m[i + 1][jj - 1], m[i + 2][jj - 2], m[i + 3][jj - 3]]));
            }

            sol += xmas.Count(str => str is "XMAS" or "SAMX");
        }

        return sol;
    }

    public static int Part2(string s)
    {
        var sol = 0;
        var m = ParseInput(s);

        for (var i = 1; i < m.Length - 1; i++)
        for (var j = 1; j < m.Length - 1; j++)
        {
            List<string> xmas =
            [
                new([m[i-1][j-1], m[i][j], m[i+1][j + 1]]),
                new([m[i-1][j+1], m[i][j], m[i+1][j - 1]]),
            ];

            if (xmas.All(str => str is "MAS" or "SAM"))
            {
                sol++;
            }
        }

        return sol;
    }
}
