test {
  let arr = [1, 2, 3, 4, 5]
  let tmp = binary_indexed.bitTree(arr)
  inspect(tmp.query(2), content="2")
  tmp.update(1, 5, 2)
  inspect(tmp.query(4), content="6")
}
