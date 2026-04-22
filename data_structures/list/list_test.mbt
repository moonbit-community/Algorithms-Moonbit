///|
test "foreach" {
  let list : List[Int] = Cons(1, Cons(2, Cons(3, Nil)))
  inspect(
    for current = list, arr = [] {
      match current {
        Nil => break arr
        Cons(x, t) => continue t, arr + [x]
      }
    },
    content="[1, 2, 3]",
  )
}
