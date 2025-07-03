test {
  let arr = [1, 2, 3, 4, 5]
  let tmp = bitTree(arr)
  inspect(query(2), content="2")
  tmp.update(1, 5, 2)
  inspect(query(4), content="6")
}
