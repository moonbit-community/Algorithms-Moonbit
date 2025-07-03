///|
enum Prefix1d {
  Nil
  Pre(Array[Int], Int)
} derive(Show)

///|
enum Prefix2d {
  Nil
  Pre(Array[Array[Int]], Int, Int)
} derive(Show)

// make prefix for 1 dimension
///|
fn prefix1d(data : Array[Int]) -> Array[Int] {
  let n = data.length()
  let ret = Array::make(n + 1, 0)
  if n > 0 {
    ret[1] = data[0]
    for i = 1; i < n; i = i + 1 {
      ret[i + 1] = ret[i] + data[i]
    }
  }
  ret
}

// make prefix for 2 dimension
///|
fn prefix2d(data : Array[Array[Int]]) -> Array[Array[Int]] {
  let n = data.length()
  if n == 0 {
    return []
  }
  let m = data[0].length()
  let ret = Array::makei(n + 1, fn(_row : Int) { Array::make(m + 1, 0) })
  for i = 1; i <= n; i = i + 1 {
    for j = 1; j <= m; j = j + 1 {
            ret[i][j] = ret[i][j - 1] + 
        ret[i - 1][j] - 
        ret[i - 1][j - 1] + 
        data[i - 1][j - 1]
    }
  }
  ret
}

///| Sum of 1 dimension prefix 
/// 
/// # Parameters
/// 
/// - `self` : Prefix1d
/// - `left` : start index (range from 1-n)
/// - `right` : end index (range from 1-n)
/// 
/// # Returns
/// 
/// - `Int` : Sum of intervals
///
/// # Example
/// ```
///   let a1 = [1, 2, 3, 4, 5, 6 , 1, 2]
///   let pre1 = make_prefix1d(a1)
///   inspect(sum1d(pre1, 2, 4), content="9")
/// ```
pub fn sum1d(self : Prefix1d, left : Int, right : Int) -> Int {
  match self {
    Nil => abort("Cannot sum on an empty prefix structure")
    Pre(pre, n) => {
      if left < 1 || left > n || right > n || right < 1 || left > right {
        abort("Range out of index")
      }
      pre[right] - pre[left - 1]
    }
  }
}

///| Prefix of 1 dimension array
/// 
/// # Parameters
/// 
/// - `data` : array to make prefix
/// 
/// # Returns
/// 
/// - `Prefix1d`
///
/// # Example
/// ```
/// let arr = [1, 2, 3, 4]
/// let _ = make_prefix1d(arr)
/// ```
pub fn make_prefix1d(data : Array[Int]) -> Prefix1d {
  match data.length() {
    0 => Nil
    n => Pre(prefix1d(data), n)
  }
}

///| Sum of 2 dimension prefix 
/// 
/// # Parameters
/// 
/// - `self` : Prefix1d
/// - `x1` : x index of top left point
/// - `y1` : y index of top left point
/// - `x2` : x index of bottom right point
/// - `y2` : y index of bottom right point
/// 
/// # Returns
/// 
/// - `Int` : Sum of intervals
///
/// # Example
/// ```
///   let a2 = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
///   let pre2 = make_prefix2d(a2)
///   inspect(sum2d(pre2, 2,2,3,3), content="34")
/// ```
pub fn sum2d(self : Prefix2d, x1 : Int, y1 : Int, x2 : Int, y2 : Int) -> Int {
  match self {
    Nil => abort("Cannot sum on an empty prefix structure")
    Pre(pre, n, m) => {
      if x1 < 1 || y1 < 1 || x2 > n || y2 > m || x2 < x1 || y2 < y1 {
        abort("Range out of index")
      }
      pre[x2][y2] - pre[x2][y1 - 1] - pre[x1 - 1][y2] + pre[x1 - 1][y1 - 1]
    }
  }
}

///| Prefix of 2 dimension array
/// 
/// # Parameters
/// 
/// - `data` : array to make prefix
/// 
/// # Returns
/// 
/// - `Prefix2d`
///
/// # Example
/// ```
/// let arr = [[1,2,3],[5,6,7],[9,10,11]]
/// let _ = make_prefix2d(arr)
/// ```
pub fn make_prefix2d(data : Array[Array[Int]]) -> Prefix2d {
  let n = data.length()
  if n == 0 {
    return Nil
  }
  let m = data[0].length()
  Pre(prefix2d(data), n, m)
}