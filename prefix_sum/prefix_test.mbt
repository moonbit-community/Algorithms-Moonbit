test {
  let a1 = [1, 2, 3, 4, 5, 6, 1, 2]
  let pre1 = @prefix_sum.make_prefix1d(a1)
  inspect!(pre1.sum(2, 4), content="9")
  let a2 = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]
  let pre2 = @prefix_sum.make_prefix2d(a2)
  inspect!(pre2.sum(2, 2, 3, 3), content="34")
}
