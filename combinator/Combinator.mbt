struct Comb {
     fact: Array[Int64]
     inv_fact: Array[Int64]
     mod: Int64
  }

fn qpow(base: Int64, exp: Int64, mod: Int64) -> Int64 {
    let mut res: Int64 = 1
    let mut a: Int64 = base % mod
    let mut b: Int64 = exp
    while b>0 {
      if b%2 == 1 {
          res = res * a % mod
        }    
        a = a * a % mod
        b = b >> 1
    } else {
        return res
    }
    res
  }

///| Constructor
/// 
/// # Parameters
/// 
/// - `size` : size of Combinator
/// - `mod`: the module number
/// 
/// # Returns
/// 
/// - `Comb` : a Combinator instance
/// 
/// # Example
/// ```
/// let _ = Comb::new(10,998242353)
/// ```
pub fn Comb::new(size: Int,mod: Int64) -> Comb {
    let fact: Array[Int64] = Array::make(size, 1L)
    let inv_fact: Array[Int64] = Array::make(size, 1L)
    for i in 1..<size {
        fact[i] = fact[i-1] * Int64::from_int(i) % mod
        inv_fact[i] = inv_fact[i-1] * qpow(Int64::from_int(i), mod - 2, mod) % mod
      } 

    {fact, inv_fact, mod}
}

///| Combination
/// 
/// # Parameters
/// 
/// - `self` : instance of Combinator
/// - `x` : total size of the set
/// - `y`: the number of object you want to choose
/// 
/// # Returns
/// 
/// - `Int64` : the number of choices
/// 
/// # Example
/// ```
/// let comb = Comb::new(10, 1000000007)
/// inspect(comb.c(3, 1), content="3")
/// ```
pub fn c(self: Comb, x: Int, y: Int) -> Int64 {
    if x >= self.fact.length() || x < 0 || y >= self.fact.length() || y < 0{
        abort("value out of range")
    }
    if y > x {
      abort("invalid combination")
    }
    self.fact[x] * self.inv_fact[y] % self.mod * self.inv_fact[x - y] % self.mod
  }

///| Arrangement
/// 
/// # Parameters
/// 
/// - `self` : instance of Combinator
/// - `x` : total size of the set
/// - `y`: the number of object you want to arrange
/// 
/// # Returns
/// 
/// - `Int64` : the number of arrangements
/// 
/// # Example
/// ```
/// let comb = Comb::new(10,998242353)
/// let ans = comb.a(4, 2)
/// inspect(ans, content="12")
/// ```
pub fn a(self: Comb, x: Int, y: Int) -> Int64 {
    if y == 0 {
        return 1L
      }
    if y > x {
        abort("invalid arrangement")
      }
    if x < 0 || y < 0{
        abort("value out of range")
      }
      
    let mut ans: Int64 = 1L
    for i = x; i > x - y; i = i - 1 {
        ans = ans * Int64::from_int(i) % self.mod
      }
      ans
  }
