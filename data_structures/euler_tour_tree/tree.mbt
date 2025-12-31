///|
///An Euler Tour Tree maintains a dynamic forest by storing an Euler tour
///inside a randomized treap. It supports link/cut operations and lets you
///query whether two nodes are connected along with the component size.
///
struct Node {
  id : Int
  is_vertex : Bool
  priority : Int
  mut left : Node?
  mut right : Node?
  mut parent : Node?
  mut size : Int
  mut vertex_count : Int
}

///|
fn Node::new(id : Int, is_vertex : Bool, priority : Int) -> Node {
  let count = if is_vertex { 1 } else { 0 }
  Node::{
    id,
    is_vertex,
    priority,
    left: None,
    right: None,
    parent: None,
    size: 1,
    vertex_count: count,
  }
}

///|
struct EdgeRef {
  to : Int
  out : Node
  back : Node
}

///|
fn node_size(node_opt : Node?) -> Int {
  match node_opt {
    None => 0
    Some(node) => node.size
  }
}

///|
fn node_vertex_count(node_opt : Node?) -> Int {
  match node_opt {
    None => 0
    Some(node) => node.vertex_count
  }
}

///|
fn pull(node : Node) -> Unit {
  node.size = 1 + node_size(node.left) + node_size(node.right)
  let own = if node.is_vertex { 1 } else { 0 }
  node.vertex_count = own +
    node_vertex_count(node.left) +
    node_vertex_count(node.right)
}

///|
fn merge(left_opt : Node?, right_opt : Node?) -> Node? {
  match (left_opt, right_opt) {
    (None, right_side) => right_side
    (left_side, None) => left_side
    (Some(left_value), Some(right_value)) => {
      let left = left_value
      let right = right_value
      if left.priority > right.priority {
        let merged = merge(left.right, Some(right))
        left.right = merged
        if merged is Some(node) {
          node.parent = Some(left)
        }
        pull(left)
        Some(left)
      } else {
        let merged = merge(Some(left), right.left)
        right.left = merged
        if merged is Some(node) {
          node.parent = Some(right)
        }
        pull(right)
        Some(right)
      }
    }
  }
}

///|
fn merge_root(left_opt : Node?, right_opt : Node?) -> Node? {
  let merged = merge(left_opt, right_opt)
  if merged is Some(node) {
    node.parent = None
  }
  merged
}

///|
fn split(node_opt : Node?, k : Int) -> (Node?, Node?) {
  match node_opt {
    None => (None, None)
    Some(node_value) => {
      let node = node_value
      let left_size = node_size(node.left)
      if k <= left_size {
        let (left_part, right_part) = split(node.left, k)
        node.left = right_part
        if right_part is Some(child) {
          child.parent = Some(node)
        }
        pull(node)
        if left_part is Some(root) {
          root.parent = None
        }
        node.parent = None
        (left_part, Some(node))
      } else {
        let (left_part, right_part) = split(node.right, k - left_size - 1)
        node.right = left_part
        if left_part is Some(child) {
          child.parent = Some(node)
        }
        pull(node)
        node.parent = None
        if right_part is Some(root) {
          root.parent = None
        }
        (Some(node), right_part)
      }
    }
  }
}

///|
fn root_of(node : Node) -> Node {
  let mut current = node
  while current.parent is Some(parent) {
    current = parent
  }
  current
}

///|
fn node_index(node : Node) -> Int {
  let mut idx = node_size(node.left)
  let mut current = node
  while current.parent is Some(parent) {
    if parent.right is Some(right_node) && right_node.id == current.id {
      idx = idx + 1 + node_size(parent.left)
    }
    current = parent
  }
  idx
}

///|
pub struct EulerTourTree {
  nodes : Array[Node]
  adjacency : Array[Array[EdgeRef]]
  mut rng_state : Int
  mut next_id : Int
}

///|
///Creates a new Euler Tour Tree with `size` isolated vertices.
///
///# Example
///```
///  let ett = EulerTourTree::new(3)
///  assert_eq(ett.component_size(0), 1)
///```
///
pub fn EulerTourTree::new(size : Int) -> EulerTourTree {
  let nodes = Array::make(size, Node::new(0, true, 1))
  let adjacency = Array::make(size, Array::new())
  let mut rng_state = 123_456_789
  for i in 0..<size {
    rng_state = next_priority(rng_state)
    nodes[i] = Node::new(i, true, rng_state)
    adjacency[i] = Array::new()
  }
  { nodes, adjacency, rng_state, next_id: size }
}

///|
///Returns the number of vertices in the forest.
///
pub fn EulerTourTree::len(self : EulerTourTree) -> Int {
  self.nodes.length()
}

///|
///Checks whether two vertices are connected.
///
///# Example
///```
///  let ett = EulerTourTree::new(2)
///  assert_eq(ett.connected(0, 1), false)
///```
///
pub fn EulerTourTree::connected(self : EulerTourTree, u : Int, v : Int) -> Bool {
  if u == v {
    return true
  }
  let root_u = root_of(self.nodes[u])
  let root_v = root_of(self.nodes[v])
  root_u.id == root_v.id
}

///|
///Returns the number of vertices in the connected component containing `v`.
///
///# Example
///```
///  let ett = EulerTourTree::new(2)
///  ett.link(0, 1)
///  assert_eq(ett.component_size(0), 2)
///```
///
pub fn EulerTourTree::component_size(self : EulerTourTree, v : Int) -> Int {
  let root = root_of(self.nodes[v])
  root.vertex_count
}

///|
///Links two different trees by adding the edge `(u, v)`.
///Returns `false` if the vertices are already connected.
///
///# Example
///```
///  let ett = EulerTourTree::new(2)
///  assert_eq(ett.link(0, 1), true)
///  assert_eq(ett.link(0, 1), false)
///```
///
pub fn EulerTourTree::link(self : EulerTourTree, u : Int, v : Int) -> Bool {
  if u == v {
    return false
  }
  if self.connected(u, v) {
    return false
  }
  self.make_root(u)
  self.make_root(v)
  let edge_uv = self.new_edge_node()
  let edge_vu = self.new_edge_node()
  let root_u = root_of(self.nodes[u])
  let root_v = root_of(self.nodes[v])
  let merged = merge_root(
    merge_root(merge_root(Some(root_u), Some(edge_uv)), Some(root_v)),
    Some(edge_vu),
  )
  if merged is Some(root) {
    root.parent = None
  }
  self.adjacency[u].push(EdgeRef::{ to: v, out: edge_uv, back: edge_vu })
  self.adjacency[v].push(EdgeRef::{ to: u, out: edge_vu, back: edge_uv })
  true
}

///|
///Cuts the edge `(u, v)` if it exists.
///Returns `true` if an edge was removed.
///
///# Example
///```
///  let ett = EulerTourTree::new(2)
///  ett.link(0, 1)
///  assert_eq(ett.cut(0, 1), true)
///```
///
pub fn EulerTourTree::cut(self : EulerTourTree, u : Int, v : Int) -> Bool {
  let edge_index = find_edge_index(self.adjacency[u], v)
  if edge_index is None {
    return false
  }
  let index = edge_index.unwrap()
  let edge = remove_edge(self.adjacency[u], index)
  let back_index = find_edge_index(self.adjacency[v], u).unwrap()
  let _ = remove_edge(self.adjacency[v], back_index)
  let mut node_uv = edge.out
  let mut node_vu = edge.back
  let mut i = node_index(node_uv)
  let mut j = node_index(node_vu)
  if i > j {
    let temp_node = node_uv
    node_uv = node_vu
    node_vu = temp_node
    let temp = i
    i = j
    j = temp
  }
  let root = root_of(node_uv)
  let (left_part, rest) = split(Some(root), i)
  let (_uv_opt, rest) = split(rest, 1)
  let (middle_part, rest) = split(rest, j - i - 1)
  let (_vu_opt, right_part) = split(rest, 1)
  let _ = merge_root(left_part, right_part)
  if middle_part is Some(root_middle) {
    root_middle.parent = None
  }
  true
}

///|
fn EulerTourTree::make_root(self : EulerTourTree, v : Int) -> Unit {
  let node = self.nodes[v]
  let root = root_of(node)
  let idx = node_index(node)
  let (left_part, right_part) = split(Some(root), idx)
  let _ = merge_root(right_part, left_part)

}

///|
fn next_priority(state : Int) -> Int {
  let modulus = 2_147_483_647
  let mut next = (state * 1_103_515_245 + 12_345) % modulus
  if next < 0 {
    next = -next
  }
  if next == 0 {
    next = 1
  }
  next
}

///|
fn EulerTourTree::new_edge_node(self : EulerTourTree) -> Node {
  self.rng_state = next_priority(self.rng_state)
  let node = Node::new(self.next_id, false, self.rng_state)
  self.next_id = self.next_id + 1
  node
}

///|
fn find_edge_index(edges : Array[EdgeRef], to : Int) -> Int? {
  for i in 0..<edges.length() {
    if edges[i].to == to {
      return Some(i)
    }
  }
  None
}

///|
fn remove_edge(edges : Array[EdgeRef], index : Int) -> EdgeRef {
  let last = edges.length() - 1
  let removed = edges[index]
  edges[index] = edges[last]
  let _ = edges.pop()
  removed
}
