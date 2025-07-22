///|
struct DSU {
  parent: Array[Int]
  siz: Array[Int]
}

///|
///| Construct a dsu structure
/// 
/// # Parameters
/// 
/// - `n` : Size of the DSU
/// 
/// # Returns
/// 
/// - `DSU` : The DSU structure with size n
///
/// # Example
/// ```
///   let dsu = DSU::new(3);
///   let flag = dsu.merge(1,2)
///   assert_eq(dsu.find(1), dsu.find(2))
///   inspect(flag, content="true")
/// ```
pub fn DSU::new(n: Int) -> DSU {
    let parent = Array::make(n, 0)
    let siz = Array::make(n, 1)
    for i = 0; i < n; i = i + 1 {
        parent[i] = i
    }
    
    { parent, siz } 
  }

///| Find the root of x
/// 
/// # Parameters
/// 
/// - `self` : An instance of the DSU structure
/// - `x` : A node
/// 
/// # Returns
/// 
/// - `Int` : The father of the union that x belongs to
///
/// # Example
/// ```
///   let dsu = DSU::new(3);
///   let flag = dsu.merge(1,2)
///   assert_eq(dsu.find(1), dsu.find(2))
///   inspect(flag, content="true")
/// ```
pub fn find(self: DSU, x: Int) -> Int {
    if self.parent[x] == x {
        return x
      }
      let root = self.find(self.parent[x])
      self.parent[x] = root
      root
  }

///| Merge two unions x and y into one unoin
/// 
/// # Parameters
/// 
/// - `self` : An instance of the DSU structure
/// - `x` : A node
/// - `y` : Another node
/// 
/// # Returns
/// 
/// - `Bool` : The fact that if this merge operation success
///
/// # Example
/// ```
///   let dsu = DSU::new(3);
///   let flag = dsu.merge(1,2)
///   assert_eq(dsu.find(1), dsu.find(2))
///   inspect(flag, content="true")
/// ```
pub fn merge(self: DSU, x: Int, y: Int) -> Bool {
    let fx = self.find(x)
    let fy = self.find(y)

    if fx == fy {
        return false
      }
      if self.siz[fx] < self.siz[fy] {
          self.parent[fx] = fy
          self.siz[fy] += self.siz[fx]
      } else {
          self.parent[fy] = fx
          self.siz[fx] += self.siz[fy]
        } 
      true
  }

///| Find out that if x and y belong to the same union
/// 
/// # Parameters
/// 
/// - `self` : An instance of the DSU structure
/// - `x` : A node
/// - `y` : Another node
/// 
/// # Returns
/// 
/// - `Bool` : The fact that if x and y belong to the same union.
///
/// # Example
/// ```
///   let dsu = DSU::new(3);
///   let flag = dsu.merge(1,2)
///   assert_eq(dsu.find(1), dsu.find(2))
///   inspect(flag, content="true")
/// ```
pub fn same(self: DSU, x: Int, y: Int) -> Bool {
    self.find(x) == self.find(y)
  }

///| Get the size of the union that x belongs to
/// 
/// # Parameters
/// 
/// - `self` : An instance of the DSU structure
/// - `x` : A node
/// 
/// # Returns
/// 
/// - `Int` : The size of the union
///
/// # Example
/// ```
///   let dsu = DSU::new(3);
///   let flag = dsu.merge(1,2)
///   assert_eq(dsu.find(1), dsu.find(2))
///   inspect(flag, content="true")
/// ```
pub fn size(self: DSU, x: Int) -> Int {
    self.siz[self.find(x)]
  }
