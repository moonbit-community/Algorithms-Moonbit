///|
///Heavy-Light Decomposition splits a tree into heavy paths so that any path
///query can be expressed as a small number of contiguous segments on the
///flattened array order.
///
struct HeavyLightDecomposition {
  adj_head : Array[Int]
  adj_to : Array[Int]
  adj_next : Array[Int]
  mut edge_idx : Int
  parent : Array[Int]
  depth : Array[Int]
  heavy : Array[Int]
  chain_head : Array[Int]
  pos : Array[Int]
  order : Array[Int]
  size : Array[Int]
  mut current_pos : Int
  n : Int
  root : Int
}

///|
///Creates a heavy-light decomposition from an undirected tree.
///
///# Parameters
///- `n` : number of nodes, indexed from `0` to `n - 1`.
///- `edges` : list of undirected edges `(u, v)`.
///- `root~` : root of the tree (default is `0`).
///
///# Example
///```
///  let edges = [(0, 1), (1, 2), (1, 3), (3, 4)]
///  let hld = HeavyLightDecomposition::new(5, edges)
///  inspect(hld.lca(2, 4), content="1")
///```
///
pub fn HeavyLightDecomposition::new(
  n : Int,
  edges : Array[(Int, Int)],
  root? : Int = 0,
) -> HeavyLightDecomposition {
  if n <= 0 {
    abort("Tree must contain at least one node")
  }
  let root = root
  if root < 0 || root >= n {
    abort("Root out of range")
  }
  if edges.length() != n - 1 {
    abort("Tree must have exactly n - 1 edges")
  }
  let hld = HeavyLightDecomposition::{
    adj_head: Array::make(n, -1),
    adj_to: Array::make(edges.length() * 2, 0),
    adj_next: Array::make(edges.length() * 2, 0),
    edge_idx: 0,
    parent: Array::make(n, -1),
    depth: Array::make(n, 0),
    heavy: Array::make(n, -1),
    chain_head: Array::make(n, 0),
    pos: Array::make(n, 0),
    order: Array::make(n, 0),
    size: Array::make(n, 0),
    current_pos: 0,
    n,
    root,
  }
  for edge in edges {
    let (u, v) = edge
    hld.add_edge(u, v)
    hld.add_edge(v, u)
  }
  hld.depth[root] = 0
  let _ = hld.dfs_size(root, -1)
  hld.dfs_decompose(root, root)
  hld
}

///|
///Returns the number of nodes in the tree.
///
pub fn HeavyLightDecomposition::len(self : HeavyLightDecomposition) -> Int {
  self.n
}

///|
///Returns the root node used for the decomposition.
///
pub fn HeavyLightDecomposition::get_root(self : HeavyLightDecomposition) -> Int {
  self.root
}

///|
///Returns the parent of a node (`-1` for the root).
///
pub fn HeavyLightDecomposition::get_parent(
  self : HeavyLightDecomposition,
  node : Int,
) -> Int {
  self.parent[node]
}

///|
///Returns the depth of a node from the root.
///
pub fn HeavyLightDecomposition::get_depth(
  self : HeavyLightDecomposition,
  node : Int,
) -> Int {
  self.depth[node]
}

///|
///Returns the heavy-light position index of a node.
///
pub fn HeavyLightDecomposition::position(
  self : HeavyLightDecomposition,
  node : Int,
) -> Int {
  self.pos[node]
}

///|
///Returns the node stored at a position in the flattened order.
///
pub fn HeavyLightDecomposition::node_at(
  self : HeavyLightDecomposition,
  position : Int,
) -> Int {
  self.order[position]
}

///|
///Returns the inclusive range that covers the subtree of `node`.
///
pub fn HeavyLightDecomposition::subtree_range(
  self : HeavyLightDecomposition,
  node : Int,
) -> (Int, Int) {
  let left = self.pos[node]
  let right = left + self.size[node] - 1
  (left, right)
}

///|
///Finds the lowest common ancestor of nodes `u` and `v`.
///
pub fn HeavyLightDecomposition::lca(
  self : HeavyLightDecomposition,
  u : Int,
  v : Int,
) -> Int {
  let mut u = u
  let mut v = v
  while self.chain_head[u] != self.chain_head[v] {
    if self.depth[self.chain_head[u]] > self.depth[self.chain_head[v]] {
      u = self.parent[self.chain_head[u]]
    } else {
      v = self.parent[self.chain_head[v]]
    }
  }
  if self.depth[u] < self.depth[v] {
    u
  } else {
    v
  }
}

///|
///Collects the flattened segments that cover the path between `u` and `v`.
///
///The returned segments are inclusive index ranges on the flattened array.
///They are suitable for commutative path queries such as sum or min.
///
///# Example
///```
///  let edges = [(0, 1), (1, 2), (1, 3)]
///  let hld = HeavyLightDecomposition::new(4, edges)
///  let segments = hld.path_segments(2, 3)
///```
///
pub fn HeavyLightDecomposition::path_segments(
  self : HeavyLightDecomposition,
  u : Int,
  v : Int,
) -> Array[(Int, Int)] {
  let mut u = u
  let mut v = v
  let segments : Array[(Int, Int)] = []
  while self.chain_head[u] != self.chain_head[v] {
    if self.depth[self.chain_head[u]] < self.depth[self.chain_head[v]] {
      let tmp = u
      u = v
      v = tmp
    }
    let head = self.chain_head[u]
    let left = self.pos[head]
    let right = self.pos[u]
    if left <= right {
      segments.push((left, right))
    } else {
      segments.push((right, left))
    }
    u = self.parent[head]
  }
  let left = self.pos[u]
  let right = self.pos[v]
  if left <= right {
    segments.push((left, right))
  } else {
    segments.push((right, left))
  }
  segments
}

///|
///Reorders values into the flattened heavy-light order.
///
pub fn[T] HeavyLightDecomposition::reorder(
  self : HeavyLightDecomposition,
  values : Array[T],
) -> Array[T] {
  if values.length() != self.n {
    abort("Values length must match the number of nodes")
  }
  if self.n == 0 {
    return []
  }
  let reordered = Array::make(self.n, values[0])
  for node in 0..<self.n {
    reordered[self.pos[node]] = values[node]
  }
  reordered
}

///|
fn HeavyLightDecomposition::add_edge(
  self : HeavyLightDecomposition,
  u : Int,
  v : Int,
) -> Unit {
  let idx = self.edge_idx
  self.adj_to[idx] = v
  self.adj_next[idx] = self.adj_head[u]
  self.adj_head[u] = idx
  self.edge_idx = idx + 1
}

///|
fn HeavyLightDecomposition::dfs_size(
  self : HeavyLightDecomposition,
  node : Int,
  parent : Int,
) -> Int {
  self.parent[node] = parent
  self.size[node] = 1
  self.heavy[node] = -1
  let mut max_child = 0
  for i = self.adj_head[node]; i != -1; i = self.adj_next[i] {
    let child = self.adj_to[i]
    if child == parent {
      continue
    }
    self.depth[child] = self.depth[node] + 1
    let subtree_size = self.dfs_size(child, node)
    self.size[node] += subtree_size
    if subtree_size > max_child {
      max_child = subtree_size
      self.heavy[node] = child
    }
  }
  self.size[node]
}

///|
fn HeavyLightDecomposition::dfs_decompose(
  self : HeavyLightDecomposition,
  node : Int,
  head : Int,
) -> Unit {
  self.chain_head[node] = head
  let position = self.current_pos
  self.pos[node] = position
  self.order[position] = node
  self.current_pos = position + 1
  let heavy_child = self.heavy[node]
  if heavy_child != -1 {
    self.dfs_decompose(heavy_child, head)
  }
  for i = self.adj_head[node]; i != -1; i = self.adj_next[i] {
    let child = self.adj_to[i]
    if child == self.parent[node] || child == heavy_child {
      continue
    }
    self.dfs_decompose(child, child)
  }
}
