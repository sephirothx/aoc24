namespace aoc24.Days;

public static class Day1
{
    public class Input
    {
        internal List<int>[] Columns = [[], []];
    }

    public static Input ParseInput(string s)
    {
        var ret = new Input();
        using var sr = new StringReader(s);
        while (sr.ReadLine() is { } line)
        {
            foreach (var (n, i) in line.Split("   ").Select((n, i) => (n, i)))
            {
                ret.Columns[i].Add(int.Parse(n));
            }
        }
        return ret;
    }

    public static int Part1(Input input)
    {
        var list1 = input.Columns[0];
        var list2 = input.Columns[1];
        list1.Sort();
        list2.Sort();
        return list1.Zip(list2).Sum(pair => Math.Abs(pair.First - pair.Second));
    }

    public static int Part2(Input input)
    {
        var solution = 0;
        var cache = new Dictionary<int, int>();

        foreach (var i in input.Columns[0])
        {
            if (!cache.ContainsKey(i))
            {
                var count = input.Columns[1].Count(j => j == i);
                cache[i] = count;
            }

            solution += i * cache[i];
        }

        return solution;
    }
}
