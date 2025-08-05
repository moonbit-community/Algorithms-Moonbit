///|
test {
  let a1 = [1, 2, 3, 4, 5, 6, 1, 2]
  let pre1 = Prefix1d::from(a1)
  inspect(pre1.sum(2, 4), content="9")
  let a2 = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]
  let pre2 = Prefix2d::from(a2)
  inspect(pre2.sum(2, 2, 3, 3), content="34")
  let a3 = [1.1, 2.2, 3.3, 4.4]
  let pre3 = Prefix1d::from(a3)
  inspect(pre3.sum(1, 3), content="6.6")
}
