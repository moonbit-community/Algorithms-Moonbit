///|
struct LCA {
  head : Array[Int32]
  to : Array[Int32]
  next : Array[Int32]
  mut idx : Int32
  dep : Array[Int32]
  fa : Array[Array[Int32]]
  n : Int32
  root : Int32
}

///|
pub fn LCA::get_root(self : LCA) -> Int32 {
  self.root
}

///|
fn LCA::new(size : Int32, root : Int32) -> LCA {
  let size = size + 2
  LCA::{
    head: Array::make(size, -1),
    to: Array::make(size * 2, 0),
    next: Array::make(size * 2, 0),
    idx: 0,
    dep: Array::make(size, 0),
    fa: Array::makei(size, fn(_row : Int32) -> Array[Int32] {
      Array::make(@math.log2(size.to_double()).to_int() + 1, 0)
    }),
    n: size - 1,
    root,
  }
}

///|
fn LCA::add(self : LCA, u : Int32, v : Int32) -> Unit {
  let idx = self.idx
  self.to[idx] = v
  self.next[idx] = self.head[u]
  self.head[u] = idx
  self.idx = idx + 1
}

///|
fn LCA::dfs0(self : LCA, u : Int32, f : Int32, d : Int32) -> Unit {
  self.dep[u] = d
  for i = self.head[u]; i != -1; i = self.next[i] {
    let v = self.to[i]
    if v == f {
      continue
    }
    self.fa[v][0] = u
    self.dfs0(v, u, d + 1)
  }
}

///|
fn LCA::_init(self : LCA) -> Unit {
  for j = 1; j <= @math.log2(self.n.to_double()).to_int(); j = j + 1 {
    for i = 1; i <= self.n; i = i + 1 {
      self.fa[i][j] = self.fa[self.fa[i][j - 1]][j - 1]
    }
  }
}

///|
/// Create LCA (Lowest Common Ancestor)
/// 
/// # Parameters
/// 
/// - `data` : Array of tuples representing the edges of the tree
/// - `root~` : Root of the tree (default is 1)
/// 
/// # Returns
/// 
/// - `LCA` : An instance of the LCA structure
///
/// # Example
/// ```
///   let data = [(1, 2), (1, 3), (2, 4), (2, 5)]
///   let lca = create_Lca(data, root = 1)
///   inspect(lca.get_root(), content="1")
/// ```
pub fn create_Lca(data : Array[(Int32, Int32)], root~ : Int32 = 1) -> LCA {
  if data.length() == 0 {
    abort("Data is empty")
  } else if root < 1 || root > data.length() {
    abort("Root out of index")
  }
  let lca = LCA::new(data.length(), root)
  for p in data {
    let (u, v) = p
    lca.add(u, v)
  }
  lca.dfs0(root, 0, 1)
  lca._init()
  lca
}

///|
/// Find LCA (Lowest Common Ancestor)
/// 
/// # Parameters
/// 
/// - `self` : An instance of the LCA structure
/// - `u` : First node
/// - `v` : Second node
/// 
/// # Returns
/// 
/// - `Int` : The lowest common ancestor of nodes `u` and `v`
///
/// # Example
/// ```
///   let data = [(1, 2), (1, 3), (2, 4), (2, 5)]
///   let lca = create_Lca(data, root = 1)
///   inspect(lca.lca(4, 5), content="2")
///   inspect(lca.lca(4, 3), content="1")
/// ```
pub fn LCA::lca(self : LCA, u : Int32, v : Int32) -> Int32 {
  let _ = self.root
  let mut u = u
  let mut v = v
  if self.dep[u] < self.dep[v] {
    let tmp = u
    u = v
    v = tmp
  }
  for i = @math.log2(self.n.to_double() + 1).to_int(); i >= 0; i = i - 1 {
    if self.dep[self.fa[u][i]] >= self.dep[v] {
      u = self.fa[u][i]
    }
  }
  if u == v {
    return u
  }
  for i = @math.log2(self.n.to_double() + 1).to_int(); i >= 0; i = i - 1 {
    if self.fa[u][i] != self.fa[v][i] {
      u = self.fa[u][i]
      v = self.fa[v][i]
    }
  }
  self.fa[u][0]
}
