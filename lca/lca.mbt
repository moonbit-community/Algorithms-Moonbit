///|
struct LCA {
  head : Array[Int]
  to : Array[Int]
  next : Array[Int]
  mut idx : Int
  dep : Array[Int]
  fa : Array[Array[Int]]
  n : Int
  root : Int
}

///|
fn LCA::new(size : Int, root : Int) -> LCA {
  let size = size + 2
  LCA::{
    head: Array::make(size, -1),
    to: Array::make(size * 2, 0),
    next: Array::make(size * 2, 0),
    idx: 0,
    dep: Array::make(size, 0),
    fa: Array::makei(size, fn(row : Int) -> Array[Int] {
      Array::make(@math.log2(size.to_double()).to_int() + 1, 0)
    }),
    n: size - 1,
    root,
  }
}

///|
fn add(self : LCA, u : Int, v : Int) -> Unit {
  let idx = self.idx
  self.to[idx] = v
  self.next[idx] = self.head[u]
  self.head[u] = idx
  self.idx = idx + 1
}

///|
fn dfs0(self : LCA, u : Int, f : Int, d : Int) -> Unit {
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
fn _init(self : LCA) -> Unit {
  for j = 1; j <= @math.log2(self.n.to_double()).to_int(); j = j + 1 {
    for i = 1; i <= self.n; i = i + 1 {
      self.fa[i][j] = self.fa[self.fa[i][j - 1]][j - 1]
    }
  }
}

///| Create LCA (Lowest Common Ancestor)
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
/// test {
///   let data = [(1, 2), (1, 3), (2, 4), (2, 5)]
///   let lca = create_Lca(data, root = 1)
///   inspect!(lca.root, content="1")
/// }
/// ```
pub fn create_Lca(data : Array[(Int, Int)], root~ : Int = 1) -> LCA {
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

///| Find LCA (Lowest Common Ancestor)
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
/// test {
///   let data = [(1, 2), (1, 3), (2, 4), (2, 5)]
///   let lca = create_Lca(data, root = 1)
///   inspect!(lca.lca(4, 5), content="2")
///   inspect!(lca.lca(4, 3), content="1")
/// }
/// ```
pub fn lca(self : LCA, u : Int, v : Int) -> Int {
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
