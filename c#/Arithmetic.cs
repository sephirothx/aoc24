namespace aoc24;

public static class Arithmetic
{
    public static int Gcd(int a, int b)
        => (int)Gcd((long)a, b);

    public static int Lcm(int a, int b)
    {
        return a / Gcd(a, b) * b;
    }

    public static long Gcd(long a, long b)
    {
        a = Math.Abs(a);
        b = Math.Abs(b);

        while (a != 0 && b != 0)
        {
            if (a > b)
                a %= b;
            else
                b %= a;
        }

        var gcd = a == 0 ? b : a;

        return gcd;
    }

    public static long Lcm(long a, long b)
    {
        return a / Gcd(a, b) * b;
    }
}
