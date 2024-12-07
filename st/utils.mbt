fn max[T : Compare](a : T, b : T) -> T { if a > b {a} else {b} }

fn make_2d(rows : Int, cols : Int) -> Array[Array[Int]] {
  if rows == 0 || cols == 0 {
    [[]]
  } else {
    Array::makei(
      rows,
      fn(row : Int) -> Array[Int] {
        Array::make(cols, 0)
      },
    )
  }
}
