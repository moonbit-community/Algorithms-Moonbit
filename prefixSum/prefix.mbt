enum Prefix1d {
  Nil
  Pre(pre~ : Array[Int], n~ : Int)
} derive(Show)

enum Prefix2d {
  Nil
  Pre(pre~ : Array[Array[Int]], n~ : Int, m~ : Int)
} derive(Show)

// make prefix for 1 dimension
fn prefix1d(data : Array[Int]) -> Array[Int] {
  let n = data.length()
  let ret = Array::make(n + 1, 0)
  ret[1] = data[0]
  for i = 1; i < n; i=i+1 {
    ret[i+1] = ret[i] + data[i]
  }
  ret
}

// make prefix for 2 dimension
fn prefix2d(data : Array[Array[Int]]) -> Array[Array[Int]] {
  let n = data.length()
  let m = data[0].length()
  let ret = Array::makei(
    n + 1, 
    fn(row : Int){
      Array::make(m + 1, 0)
    }
  )
  for j = 1; j <= m; j = j+1 {
    for i = 1; i <= n; i = i+1 {
      ret[i][j] = ret[i][j-1] + ret[i-1][j] - ret[i-1][j-1] + data[i-1][j-1]
    }
  }
  println(ret)
  ret
}


/// Sum of 1 dimension prefix 
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
/// test {
///   let a1 = [1, 2, 3, 4, 5, 6 , 1, 2]
///   let pre1 = @prefixSum.make_prefix1d(a1)
///   inspect!(pre1.sum(2,4), content="9")
/// }
/// ```
pub fn sum(self : Prefix1d, left : Int, right : Int) -> Int {
  guard let Prefix1d::Pre(pre = pre, n = n) = self
  if left < 1 || left > n || right > n || right < 1 || left > right{
    abort("Range out of index")
  }
  pre[right] - pre[left-1]
}

/// Prefix of 1 dimension array
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
/// let prefix = make_prefix1d(arr)
/// ```
pub fn make_prefix1d(data : Array[Int]) -> Prefix1d {
  match (data.length()) {
    (0) => Nil
    (_) => { 
      Pre (pre = prefix1d(data), n = data.length())
    }
  }
}


/// Sum of 2 dimension prefix 
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
/// test {
///   let a2 = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
///   let pre2 = @prefixSum.make_prefix2d(a2)
///   inspect!(pre2.sum(2,2,3,3), content="34")
/// }
/// ```
pub fn sum(self : Prefix2d, x1 : Int, y1 : Int, x2 : Int, y2 : Int) -> Int {
  guard let Prefix2d::Pre(pre = pre, n = n, m = m) = self
  if x1 < 1 || y1 < 1 || x2 > n || y2 > m || x2 < x1 || y2 < y1 {
    abort("Range out of index")
  }
  pre[x2][y2] - pre[x2][y1-1] - pre[x1-1][y2] + pre[x1-1][y1-1]
}

/// Prefix of 2 dimension array
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
/// let prefix = make_prefix2d(arr)
/// ```
pub fn make_prefix2d(data : Array[Array[Int]]) -> Prefix2d {
  match (data.length()) {
    (0) => Nil
    (_) => { 
      Pre (pre = prefix2d(data), n = data.length(), m = data[0].length())
    }
  }
}

