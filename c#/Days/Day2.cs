namespace aoc24.Days;

public static class Day2
{
    public class Input
    {
        public List<List<int>> Reports = [];
    }

    public static Input ParseInput(string s)
    {
        var ret = new Input();
        using var sr = new StringReader(s);
        while (sr.ReadLine() is { } line)
        {
            ret.Reports.Add(line.Split(' ').Select(int.Parse).ToList());
        }
        return ret;
    }

    public static int Part1(Input input)
    {
        return input.Reports.Count(IsValidReport);
    }

    public static int Part2(Input input)
    {
        return input.Reports
            .Count(r => IsValidReport(r) ||
                        Enumerable.Range(0, r.Count)
                            .Any(i =>
                            {
                                var r1 = new List<int>(r);
                                r1.RemoveAt(i);
                                return IsValidReport(r1);
                            }));
    }

    private static bool IsValidReport(List<int> r)
    {
        bool inc = true, dec = true;

        foreach (var (n1, n2) in r.Zip(r.Skip(1)))
        {
            var diff = n2 - n1;
            if (diff <= 0) inc = false;
            if (diff >= 0) dec = false;
            if ((!inc && !dec) || Math.Abs(diff) > 3) return false;
        }

        return true;
    }
}
