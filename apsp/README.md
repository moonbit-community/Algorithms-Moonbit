# Algorithm-Lib-Moonbit

## Floyd Algorithm (All-Pairs Shortest Path)

This library provides an implementation of the Floyd algorithm, which is used to find the shortest paths between all pairs of nodes in a weighted graph.

### Usage

To use the Floyd algorithm, you can call the `create_floyd` function with an array of edges and the number of nodes as parameters. The function will return an instance of the `Floyd` structure. You can then use the `query` function to find the shortest path between any two nodes.

#### Parameters

- `edge`: Array of tuples representing the edges of the graph (u, v, weight).
- `node`: Number of nodes in the graph.

#### Returns

- `Floyd`: An instance of the Floyd structure.

### Example

```moonbit
let edge = [(1, 2, 3), (2, 3, 4), (1, 3, 10)]
let floyd = create_floyd(edge, 3)

// Query the shortest path between nodes 1 and 3
let shortest_path = floyd.query(1, 3)
inspect!(shortest_path, content="7")
```

In the example above, the `create_floyd` function is called with an array of edges and the number of nodes. The `query` function is then used to find the shortest path between nodes 1 and 3, which is 7.