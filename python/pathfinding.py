from heapq import heappop, heappush
from typing import Any, Callable, Dict, List, Tuple

def dijkstra(
    start: Any,
    end: Any,
    get_neighbors: Callable[[Any], List[Tuple[Any, int]]]
) -> Tuple[int, List[Any], Dict[Any, int]]:
    """
    Dijkstra's algorithm to find the shortest path from `start` to `end`.

    Args:
        start: The starting node.
        end: The ending node.
        get_neighbors: A function that takes a node as input and returns a list of
                       tuples (neighbor, cost) representing the neighbors of the node
                       and the cost to reach them.

    Returns:
        A tuple containing:
            - The length of the minimum path between `start` and `end`
            - The list of all nodes in the minimum path
            - A dictionary containing the shortest distance from `start` to each node
    """
    # Priority queue to keep track of (current distance, current node)
    pq = [(0, start)]

    # Dictionary to store the shortest known distance to each node
    distances = {start: 0}

    # Dictionary to store the path to reconstruct the shortest path
    previous = {start: None}

    visited = set()

    while pq:
        current_distance, current_node = heappop(pq)

        if current_node in visited:
            continue
        visited.add(current_node)

        # If we reach the target node, stop and reconstruct the path
        if current_node == end:
            path = []
            while current_node:
                path.append(current_node)
                current_node = previous[current_node]
            return current_distance, path[::-1], distances

        # Explore neighbors
        for neighbor, cost in get_neighbors(current_node):
            new_distance = current_distance + cost

            # If this path is shorter, update distances and queue
            if neighbor not in distances or new_distance < distances[neighbor]:
                distances[neighbor] = new_distance
                previous[neighbor] = current_node
                heappush(pq, (new_distance, neighbor))

    # If the target node is unreachable, return infinite distance and empty path
    return float('inf'), [], distances

if __name__ == "__main__":
    from input import get_all_positions_of
    from geometry import get_neighbors, is_in_bounds
    m = ["|#...#|",
         "|#.#.#|",
         "|#.#+-+",
         "|#.#|#.",
         "+-+#|#.",
         ".#+-+#.",
         ".#####.",
         ".......",]
    size = (len(m), len(m[0]))
    walls = get_all_positions_of("#", m)
    def gn(pos):
        return [(x, 1) for x in get_neighbors(pos) if is_in_bounds(x, (0, 0), size) and x not in walls]
    distance, path, distances = dijkstra((0,0), (0,6), gn)
    print("Distance:", distance)
    print("Path:", path)
    print("Distances:", distances)
