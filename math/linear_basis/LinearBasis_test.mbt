///|
test "insertion and dimension" {
  let basis = LinearBasis::new(60)
  inspect(basis.insert(1L), content="true")
  inspect(basis.insert(2L), content="true")
  inspect(basis.insert(3L), content="false")
  inspect(basis.dimension(), content="2")
}

///|
test "reduction and containment" {
  let basis = LinearBasis::new(60)
  let _ = basis.insert(7L)
  let _ = basis.insert(10L)
  inspect(basis.contains(13L), content="true")
  inspect(basis.contains(5L), content="false")
  inspect(basis.reduce(13L), content="0")
  inspect(basis.reduce(4L), content="3")
}

///|
test "maximum xor queries" {
  let basis = LinearBasis::new(60)
  let _ = basis.insert(3L)
  let _ = basis.insert(10L)
  let _ = basis.insert(5L)
  inspect(basis.max_xor(0L), content="15")
  inspect(basis.max_xor(7L), content="14")
  inspect(basis.vectors().length(), content="60")
}

///|
test "kth largest enumeration" {
  let basis = LinearBasis::new(10)
  let _ = basis.insert(1L)
  let _ = basis.insert(2L)
  let _ = basis.insert(4L)
  inspect(basis.dimension(), content="3")
  inspect(basis.kth_largest(1), content="7")
  inspect(basis.kth_largest(2), content="6")
  inspect(basis.kth_largest(4), content="4")
  inspect(basis.kth_largest(7), content="1")
  inspect(basis.kth_largest(8), content="0")
}
