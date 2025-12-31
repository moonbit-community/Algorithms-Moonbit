///|
///A Link-Cut Tree supports dynamic forests with link, cut, and path queries.
///This implementation maintains path sums over `Int` values.
///
pub struct LinkCutTree {
  left : Array[Int]
  right : Array[Int]
  parent : Array[Int]
  rev : Array[Bool]
  value : Array[Int]
  sum : Array[Int]
}

///|
///Creates a new Link-Cut Tree from the given node values.
///Each node is initially an isolated tree.
///
///# Example
///```
///  let lct = LinkCutTree::new([1, 2, 3])
///  assert_eq(lct.len(), 3)
///```
///
pub fn LinkCutTree::new(values : Array[Int]) -> LinkCutTree {
  let n = values.length()
  let left = Array::make(n, -1)
  let right = Array::make(n, -1)
  let parent = Array::make(n, -1)
  let rev = Array::make(n, false)
  let value = values
  let sum = Array::make(n, 0)
  for i in 0..<n {
    sum[i] = value[i]
  }
  { left, right, parent, rev, value, sum }
}

///|
///Returns the number of nodes in the forest.
///
pub fn LinkCutTree::len(self : LinkCutTree) -> Int {
  self.value.length()
}

///|
///Updates the value stored at `index`.
///
///# Example
///```
///  let lct = LinkCutTree::new([1, 2])
///  lct.set_value(0, 5)
///```
///
pub fn LinkCutTree::set_value(
  self : LinkCutTree,
  index : Int,
  value : Int,
) -> Unit {
  self.access(index)
  self.value[index] = value
  self.pull(index)
}

///|
///Links two nodes if they are in different trees.
///Returns `true` on success, `false` if they were already connected.
///
///# Example
///```
///  let lct = LinkCutTree::new([1, 2])
///  assert_eq(lct.link(0, 1), true)
///  assert_eq(lct.link(0, 1), false)
///```
///
pub fn LinkCutTree::link(self : LinkCutTree, u : Int, v : Int) -> Bool {
  self.make_root(u)
  if self.find_root(v) == u {
    return false
  }
  self.parent[u] = v
  true
}

///|
///Cuts the edge between `u` and `v` if it exists.
///Returns `true` if the cut succeeded.
///
///# Example
///```
///  let lct = LinkCutTree::new([1, 2])
///  lct.link(0, 1)
///  assert_eq(lct.cut(0, 1), true)
///```
///
pub fn LinkCutTree::cut(self : LinkCutTree, u : Int, v : Int) -> Bool {
  self.make_root(u)
  self.access(v)
  if self.left[v] != u || self.right[u] != -1 {
    return false
  }
  self.left[v] = -1
  self.parent[u] = -1
  self.pull(v)
  true
}

///|
///Checks whether two nodes are connected in the forest.
///
///# Example
///```
///  let lct = LinkCutTree::new([1, 2])
///  assert_eq(lct.connected(0, 1), false)
///  lct.link(0, 1)
///  assert_eq(lct.connected(0, 1), true)
///```
///
pub fn LinkCutTree::connected(self : LinkCutTree, u : Int, v : Int) -> Bool {
  if u == v {
    return true
  }
  self.find_root(u) == self.find_root(v)
}

///|
///Returns the sum of values along the path between `u` and `v`.
///Returns `None` if the nodes are not connected.
///
///# Example
///```
///  let lct = LinkCutTree::new([1, 2, 3])
///  lct.link(0, 1)
///  lct.link(1, 2)
///  assert_eq(lct.path_sum(0, 2), Some(6))
///```
///
pub fn LinkCutTree::path_sum(self : LinkCutTree, u : Int, v : Int) -> Int? {
  if !self.connected(u, v) {
    return None
  }
  self.make_root(u)
  self.access(v)
  Some(self.sum[v])
}

///|
fn LinkCutTree::is_root(self : LinkCutTree, x : Int) -> Bool {
  let p = self.parent[x]
  if p == -1 {
    return true
  }
  self.left[p] != x && self.right[p] != x
}

///|
fn LinkCutTree::push(self : LinkCutTree, x : Int) -> Unit {
  if !self.rev[x] {
    return
  }
  let left_child = self.left[x]
  let right_child = self.right[x]
  self.left[x] = right_child
  self.right[x] = left_child
  if left_child != -1 {
    self.rev[left_child] = !self.rev[left_child]
  }
  if right_child != -1 {
    self.rev[right_child] = !self.rev[right_child]
  }
  self.rev[x] = false
}

///|
fn LinkCutTree::pull(self : LinkCutTree, x : Int) -> Unit {
  let mut total = self.value[x]
  let left_child = self.left[x]
  if left_child != -1 {
    total += self.sum[left_child]
  }
  let right_child = self.right[x]
  if right_child != -1 {
    total += self.sum[right_child]
  }
  self.sum[x] = total
}

///|
fn LinkCutTree::push_path(self : LinkCutTree, x : Int) -> Unit {
  if !self.is_root(x) {
    self.push_path(self.parent[x])
  }
  self.push(x)
}

///|
fn LinkCutTree::rotate(self : LinkCutTree, x : Int) -> Unit {
  let p = self.parent[x]
  let g = self.parent[p]
  let is_left = self.left[p] == x
  let b = if is_left { self.right[x] } else { self.left[x] }
  if is_left {
    self.right[x] = p
    self.left[p] = b
  } else {
    self.left[x] = p
    self.right[p] = b
  }
  if b != -1 {
    self.parent[b] = p
  }
  self.parent[p] = x
  self.parent[x] = g
  if g != -1 {
    if self.left[g] == p {
      self.left[g] = x
    } else if self.right[g] == p {
      self.right[g] = x
    }
  }
  self.pull(p)
  self.pull(x)
}

///|
fn LinkCutTree::splay(self : LinkCutTree, x : Int) -> Unit {
  self.push_path(x)
  while !self.is_root(x) {
    let p = self.parent[x]
    let g = self.parent[p]
    if !self.is_root(p) {
      if (self.left[p] == x) == (self.left[g] == p) {
        self.rotate(p)
      } else {
        self.rotate(x)
      }
    }
    self.rotate(x)
  }
}

///|
fn LinkCutTree::access(self : LinkCutTree, x : Int) -> Unit {
  let mut v = x
  let mut last = -1
  while v != -1 {
    self.splay(v)
    self.right[v] = last
    if last != -1 {
      self.parent[last] = v
    }
    self.pull(v)
    last = v
    v = self.parent[v]
  }
  self.splay(x)
}

///|
fn LinkCutTree::make_root(self : LinkCutTree, x : Int) -> Unit {
  self.access(x)
  self.rev[x] = !self.rev[x]
}

///|
fn LinkCutTree::find_root(self : LinkCutTree, x : Int) -> Int {
  self.access(x)
  let mut v = x
  self.push(v)
  while self.left[v] != -1 {
    v = self.left[v]
    self.push(v)
  }
  self.splay(v)
  v
}
