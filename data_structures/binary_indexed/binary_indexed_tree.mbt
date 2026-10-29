///|
struct Tree[T] {
  data : Array[T]
  tr : Array[T]
}

// fn op_add(self : T, other : T) -> T {self + other}

///|
fn lowbit(x : Int32) -> Int32 {
  x & -x
}

///|
fn Tree::update_in(self : Tree[Int32], x : Int32, val : Int32) -> Unit {
  for i = x; i <= self.data.length(); i = i + 1 {
    self.tr[i] += val
  }
}

///|
/// Update
/// 
/// # Parameters
/// 
/// - `data` : The array need to build
/// 
/// # Returns
/// 
/// - `Tree[Int]` : Binary Indexed Tree
///
/// # Example
/// ```
///   let arr = [1,2,3,4,5]
///   let tmp = bitTree(arr)
///   tmp.update(1,5,2)
///   inspect(tmp.query(4), content="6")
/// ```
pub fn Tree::update(
  self : Tree[Int32],
  left : Int32,
  right : Int32,
  val : Int32,
) -> Unit {
  self.update_in(left, val)
  self.update_in(right + 1, -val)
}

///|
/// Build Binary Indexed Tree
/// 
/// # Parameters
/// 
/// - `data` : The array need to build
/// 
/// # Returns
/// 
/// - `Tree[Int]` : Binary Indexed Tree
///
/// # Example
/// ```
///   let arr = [1,2,3,4,5]
///   let tmp = bitTree(arr)
///   inspect(tmp.query(2), content="2")
/// ```
pub fn Tree::query(self : Tree[Int32], x : Int32) -> Int32 {
  let mut res : Int32 = 0
  for i = x; i >= 1; i = i - lowbit(i) {
    res += self.tr[i]
  }
  res
}

///|
/// Build Binary Indexed Tree
/// 
/// # Parameters
/// 
/// - `data` : The array to build Binary Indexed Tree
/// 
/// # Returns
/// 
/// - `Tree[Int]` : Binary Indexed Tree
///
/// # Example
/// ```
/// let arr = Array::make(5, 0) 
/// let _ = bitTree(arr) 
/// ```
pub fn bitTree(data : Array[Int32]) -> Tree[Int32] {
  let sz = data.length()
  let tr = Array::make(sz + 2, 0)
  let tree = Tree::{ data, tr, }
  tree.update_in(1, data[0])
  for i = 2; i <= sz; i = i + 1 {
    tree.update_in(i, data[i - 1] - data[i - 2])
  }
  tree
}
