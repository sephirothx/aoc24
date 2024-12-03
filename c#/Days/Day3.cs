using System.Text.RegularExpressions;

namespace aoc24.Days;

public static class Day3
{
    public static int Part1(string s)
    {
        var re = new Regex(@"mul\((?<n1>\d+),(?<n2>\d+)\)");
        var matches = re.Matches(s);
        var sol = 0;

        foreach (Match match in matches)
        {
            var n1 = match.Groups["n1"].Value;
            var n2 = match.Groups["n2"].Value;
            sol += int.Parse(n1) * int.Parse(n2);
        }

        return sol;
    }

    public static int Part2(string s)
    {
        var re = new Regex(@"(?<mul>mul\((?<n1>\d+),(?<n2>\d+)\))|(?<do>do\(\))|(?<dont>don't\(\))");
        var matches = re.Matches(s);
        var sol = 0;
        var on = true;

        foreach (Match match in matches)
        {
            if (match.Groups["mul"].Success && on)
            {
                var n1 = match.Groups["n1"].Value;
                var n2 = match.Groups["n2"].Value;
                sol += int.Parse(n1) * int.Parse(n2);
            }
            else if (match.Groups["do"].Success)
            {
                on = true;
            }
            else if (match.Groups["dont"].Success)
            {
                on = false;
            }
        }

        return sol;
    }
}
