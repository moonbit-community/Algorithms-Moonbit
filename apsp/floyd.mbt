///|
struct Floyd {
  map : Array[Array[Int]]
  node : Int
}

///| Create Floyd (All-Pairs Shortest Path)
/// 
/// # Parameters
/// 
/// - `edge` : Array of tuples representing the edges of the graph (u, v, weight)
/// - `node` : Number of nodes in the graph
/// 
/// # Returns
/// 
/// - `Floyd` : An instance of the Floyd structure
///
/// # Example
/// ```
/// let edge = [(1, 2, 3), (2, 3, 4), (1, 3, 10)]
/// let floyd = create_floyd(edge, 3)
/// ```
pub fn create_floyd(edge : Array[(Int, Int, Int)], node : Int) -> Floyd {
  let map : Array[Array[Int]] = Array::makei(node + 1, fn(row : Int) {
    Array::makei(node + 1, fn(col : Int) {
      if row == col {
        0
      } else {
        0x3f3f3f3f
      }
    })
  })
  map[0][0] = @int.max_value
  for e in edge {
    let (u, v, d) = e
    map[u][v] = @math.minimum(map[u][v], d)
    map[v][u] = map[u][v]
  }
  for k = 1; k <= node; k = k + 1 {
    for i = 1; i <= node; i = i + 1 {
      for j = i + 1; j <= node; j = j + 1 {
        map[i][j] = @math.minimum(map[i][j], map[i][k] + map[k][j])
        map[j][i] = map[i][j]
      }
    }
  }
  Floyd::{ map, node }
}

///| Query shortest path
/// 
/// # Parameters
/// 
/// - `self` : An instance of the Floyd structure
/// - `u` : Start node
/// - `v` : End node
/// 
/// # Returns
/// 
/// - `Int` : The shortest path distance between nodes `u` and `v`
///
/// # Example
/// ```
/// test {
///   let edge = [(1, 2, 3), (2, 3, 4), (1, 3, 10)]
///   let floyd = create_floyd(edge, 3)
///   inspect!(floyd.query(1, 3), content="7")
/// }
/// ```
pub fn query(self : Floyd, u : Int, v : Int) -> Int {
  if u < 1 || u > self.node || v < 1 || v > self.node {
    abort("Invalid node")
  }
  self.map[u][v]
}
