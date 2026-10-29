///|
test "sort matches the standard sort across partition sizes" {
  for size in [0, 1, 2, 16, 17, 31, 64, 1000] {
    for pattern in 0..<4 {
      let values = Array::makei(size, i => {
        match pattern {
          0 => size - i
          1 => i % 7 - 3
          2 => if i % 2 == 0 { i } else { -i }
          _ => i
        }
      })
      let expected = values.copy()
      expected.sort()
      sort(values)
      assert_true(values == expected)
    }
  }
}

///|
test "heap fallback sorts only the selected mutable slice" {
  let values = [
    999, 18, 3, 16, 7, 12, 1, 9, 4, 11, 8, 2, 17, 5, 15, 6, 14, 13, 10, -999,
  ]
  introsort(values.mut_view(start=1, end=19), 0)
  assert_eq(values[0], 999)
  assert_eq(values[19], -999)
  for i in 1..<=18 {
    assert_eq(values[i], i)
  }
}
