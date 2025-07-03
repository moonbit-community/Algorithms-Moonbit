// max min test
test "min_max" {
  inspect(@algorithm.max(1, 2), content="2")
  inspect(@algorithm.min(1, 2), content="1")
  inspect(@algorithm.min(1.2, 2.1), content="1.2")
}

test "lower_bound" {
  let arr = [1, 2, 3, 4, 5]
  inspect(@algorithm.lower_bound(arr, 1), content="0")
  inspect(@algorithm.lower_bound(arr, 2), content="1")
  inspect(@algorithm.lower_bound(arr, 7), content="5")
  let arr = [1.1, 2, 3.5, 9]
  inspect(@algorithm.lower_bound(arr, 1.2), content="1")
}

test "upper_bound" {
  let arr = [1, 2, 3, 4, 5]
  inspect(@algorithm.upper_bound(arr, -1), content="0")
  inspect(@algorithm.upper_bound(arr, 2), content="2")
  inspect(@algorithm.upper_bound(arr, 7), content="5")
}

// 
test "binary_search" {
  let arr = [1, 2, 3, 4, 5]
  inspect(@algorithm.binary_search(arr, 1), content="true")
  inspect(@algorithm.binary_search(arr, 6), content="false")
  inspect(@algorithm.binary_search(arr, 0), content="false")
}

test "equal_range" {
  let arr = [1, 2, 2, 2, 3, 4, 5]
  inspect(@algorithm.equal_range(arr, 2), content="(1, 3)")
  inspect(@algorithm.equal_range(arr, 7), content="(-1, -1)")
}

test "max_element" {
  let arr = [1, 2, 3, 4, 5]
  inspect(@algorithm.max_element(arr), content="5")
  let arr = [1.1, 2.4, 3.9, 4, 5.9, 1.0]
  inspect(@algorithm.max_element(arr), content="5.9")
}

test "min_element" {
  let arr = [1, 2, 3, 4, 5]
  inspect(@algorithm.min_element(arr), content="1")
  let arr = [1.1, 2.4, 3.9, 4, 5.9, 1.2]
  inspect(@algorithm.min_element(arr), content="1.1")
}

test "merge" {
  let arr1 = [1, 2, 5]
  let arr2 = [3, 4, 6]
  inspect(@algorithm.merge(arr1, arr2), content="[1, 2, 3, 4, 5, 6]")
  let arr1 = [1, 2, 3]
  let arr2 = [4, 5, 6]
  inspect(@algorithm.merge(arr1, arr2), content="[1, 2, 3, 4, 5, 6]")
}

test "quick_pow" {
  inspect(@algorithm.quick_pow(2, 0), content="1")
  inspect(@algorithm.quick_pow(2, 1), content="2")
  inspect(@algorithm.quick_pow(2, 10), content="1024")
}

test "max_manhattan_distance" {
  let arr = [
    @algorithm.Point::{ x: 0, y: 0 },
    @algorithm.Point::{ x: 1, y: 0 },
    @algorithm.Point::{ x: 1, y: 1 },
  ]
  inspect(@algorithm.max_manhattan_distance(arr), content="2")
}

test "gcd" {
  assert_eq!(@algorithm.gcd(12, 18), 6)
  assert_eq!(@algorithm.gcd(17, 23), 1)
}

test "ext_euclidean" {
  inspect(@algorithm.ext_euc(5, 7), content="(1, 3, -2)")
}

test "mod_inverse" {
  assert_eq!(@algorithm.mod_inverse(2, 1000_000_007), 500000004)
  assert_eq!(@algorithm.mod_inverse(3, 26), 9)
}
