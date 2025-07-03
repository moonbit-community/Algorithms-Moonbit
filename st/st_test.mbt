///|
test {
  let arr = [1, 2, 3, 4, 5, 6, 1, 2]
  let st = st(arr)
  inspect(st.max_elem(1, 1), content="1")
  inspect(st.max_elem(2, 8), content="6")
}
