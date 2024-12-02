namespace aoc24;

public enum Direction
{
    Up = 1,
    Down = 2,
    Right = 3,
    Left = 4
}

public static class Geometry
{
    #region Direction

    public static (int x, int y) GetDirection(Direction dir)
    {
        return dir switch
        {
            Direction.Right => (1, 0),
            Direction.Left => (-1, 0),
            Direction.Down => (0, -1),
            Direction.Up => (0, 1),
            _ => throw new ArgumentOutOfRangeException(nameof(dir), dir, null)
        };
    }

    public static (int x, int y) RotateLeft((int x, int y) dir)
    {
        int tmp = dir.x;
        dir.x = dir.y;
        dir.y = -tmp;

        return dir;
    }

    public static (int x, int y) RotateRight((int x, int y) dir)
    {
        int tmp = dir.x;
        dir.x = -dir.y;
        dir.y = tmp;

        return dir;
    }

    public static (int x, int y) TupleSum((int x, int y) p1, (int x, int y) p2)
    {
        return (p1.x + p2.x, p1.y + p2.y);
    }

    #endregion

    #region ManhattanDistance

    public static int ManhattanDistance(int x1, int y1, int x2, int y2)
    {
        return Math.Abs(x2 - x1) + Math.Abs(y2 - y1);
    }

    public static int ManhattanDistance((int x, int y) p1, (int x, int y) p2)
        => ManhattanDistance(p1.x, p1.y, p2.x, p2.y);

    public static int ManhattanDistance(int x, int y)
        => ManhattanDistance(x, y, 0, 0);

    public static int ManhattanDistance((int x, int y) p)
        => ManhattanDistance(p.x, p.y);

    #endregion
}
