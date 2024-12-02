using System.Diagnostics;
using aoc24;
using aoc24.Days;

var input = Day2.ParseInput(Input.FetchFromWeb());

var s = Stopwatch.StartNew();
var result = Day2.Part2(input);
s.Stop();

Console.WriteLine(result);
Console.WriteLine($"Execution time: {s.Elapsed:s'.'FFFFFF}");
