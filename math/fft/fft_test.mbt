///|
test "polynomial convolution basic" {
  let a = [1, 2, 3]
  let b = [4, 5, 6]
  inspect(convolution(a, b), content="[4, 13, 28, 27, 18]")
}

///|
test "polynomial convolution handles zeros" {
  let a = [0, 1, 0, 2]
  let b = [3, 0, 4]
  inspect(convolution(a, b), content="[0, 3, 0, 10, 0, 8]")
}

///|
test "polynomial convolution with single element" {
  let a = [7]
  let b = [9, 8, 7]
  inspect(convolution(a, b), content="[63, 56, 49]")
}

///|
test "empty polynomial returns empty result" {
  let a = []
  let b = [1, 2, 3]
  inspect(convolution(a, b), content="[]")
}

///|
test "polynomial convolution both empty" {
  inspect(convolution([], []), content="[]")
}

///|
test "convolution with negatives" {
  let a = [1, -2, 3]
  let b = [-4, 5, -6]
  inspect(convolution(a, b), content="[-4, 13, -28, 27, -18]")
}

///|
test "symmetric polynomials" {
  let a = [1, 1, 1, 1]
  let b = [1, 1, 1, 1]
  inspect(convolution(a, b), content="[1, 2, 3, 4, 3, 2, 1]")
}

///|
test "delta polynomial identity" {
  let a = [0, 0, 1]
  let b = [5, 6, 7]
  inspect(convolution(a, b), content="[0, 0, 5, 6, 7]")
}

///|
test "convolution with large coefficients" {
  let a = [1000, 2000, 3000]
  let b = [4000, 5000, 6000]
  inspect(
    convolution(a, b),
    content="[4000000, 13000000, 28000000, 27000000, 18000000]",
  )
}

///|
test "power of two length polynomials" {
  let a = [1, 2, 3, 4]
  let b = [5, 6, 7, 8]
  inspect(convolution(a, b), content="[5, 16, 34, 60, 61, 52, 32]")
}

///|
test "convolution with random pattern small" {
  let a = [3, 1, 4, 1, 5]
  let b = [9, 2, 6]
  inspect(convolution(a, b), content="[27, 15, 56, 23, 71, 16, 30]")
}

///|
test "unit impulse convolution" {
  let a = [1]
  let b = [1, 2, 3, 4, 5]
  inspect(convolution(a, b), content="[1, 2, 3, 4, 5]")
}

///|
test "identity by one" {
  let a = [1, 2, 3, 4]
  let b = [1]
  inspect(convolution(a, b), content="[1, 2, 3, 4]")
}

///|
test "alternating sign polynomial" {
  let a = [1, -1, 1, -1]
  let b = [-1, 1, -1, 1]
  inspect(convolution(a, b), content="[-1, 2, -3, 4, -3, 2, -1]")
}

///|
test "zero padding equivalence" {
  let a = [1, 2]
  let b = [3, 4]
  inspect(convolution(a, b), content="[3, 10, 8]")
}

///|
test "self convolution small" {
  let a = [2, 3, 4]
  inspect(convolution(a, a), content="[4, 12, 25, 24, 16]")
}

///|
test "self convolution longer" {
  let a = [1, 3, 5, 7, 9]
  inspect(convolution(a, a), content="[1, 6, 19, 44, 85, 124, 139, 126, 81]")
}

///|
test "mirror polynomial convolution" {
  let a = [1, 2, 3]
  let b = [3, 2, 1]
  inspect(convolution(a, b), content="[3, 8, 14, 8, 3]")
}

///|
test "large n small coefficients" {
  let a = Array::make(64, 1)
  let b = Array::make(64, 1)
  let res = convolution(a, b)
  inspect(res.length(), content="127")
}

///|
test "large n all ones result correctness" {
  let a = Array::make(8, 1)
  let b = Array::make(8, 1)
  inspect(
    convolution(a, b),
    content="[1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1]",
  )
}
