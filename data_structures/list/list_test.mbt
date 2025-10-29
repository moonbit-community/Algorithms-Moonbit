///|
test "foreach" {
  let list : List[Int] = Cons(1, Cons(2, Cons(3, Nil)))
  inspect(
    loop (list, []) {
      (Nil, arr) => break arr
      (Cons(x, t), arr) => continue (t, arr + [x])
    },
    content="[1, 2, 3]",
  )
}
