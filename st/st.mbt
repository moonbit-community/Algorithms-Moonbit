///|
struct ST {
  n : Int
  f : Array[Array[Int]]
}

///| Build Sparse Table
/// 
/// # Parameters
/// 
/// - `data` : The array to build Sparse Table
/// 
/// # Returns
/// 
/// - `ST` : Sparse Table
///
/// # Example
/// ```
/// let arr = [1,2,3,4,5,6,1,2]
/// let _ = st(arr)
/// ```
pub fn st(data : Array[Int]) -> ST {
  let n = data.length()
  let range : Int = @math.log2(n.to_double()).to_int() + 1
  let f = make_2d(n + 1, range)
  for i = 0; i < n; i = i + 1 {
    f[i + 1][0] = data[i]
  }
  for j = 1; j <= range - 1; j = j + 1 {
    for i = 1; i + (1 << j) - 1 <= n; i = i + 1 {
      f[i][j] = max(f[i][j - 1], f[i + (1 << (j - 1))][j - 1])
    }
  }
  ST::{ n, f }
}

///| Build Binary Indexed Tree
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
///   let arr = [1,2,3,4,5,6,1,2]
///   let st= @st.st(arr)
///   inspect(st.max_elem(1, 1), content="1")
///   inspect(st.max_elem(2, 8), content="6")
/// ```
pub fn max_elem(self : ST, left : Int, right : Int) -> Int {
  if right < left {
    abort("Invalid range.")
  } else if left > self.n || right < 1 {
    abort("Range out of bounds.")
  }
  let k = @math.log2((right - left + 1).to_double()).to_int()
  max(self.f[left][k], self.f[right - (1 << k) + 1][k])
}
