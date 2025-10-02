///|
test "trie insertion and retrieval with chars" {
  let trie : Trie[Char, Int] = Trie::new()
  let foo = ['f', 'o', 'o']
  let foobar = ['f', 'o', 'o', 'b', 'a', 'r']
  let bar = ['b', 'a', 'r']
  trie.insert(foo.copy(), 1)
  assert_eq(trie.get(foo.copy()), Some(1))
  trie.insert(foobar.copy(), 2)
  assert_eq(trie.get(foobar.copy()), Some(2))
  assert_eq(trie.get(foo.copy()), Some(1))
  trie.insert(bar.copy(), 3)
  assert_eq(trie.get(bar.copy()), Some(3))
  let baz = ['b', 'a', 'z']
  assert_eq(trie.get(baz), None)
  let foobarbaz = ['f', 'o', 'o', 'b', 'a', 'r', 'b', 'a', 'z']
  assert_eq(trie.get(foobarbaz), None)
}

///|
test "trie insertion and retrieval with integers" {
  let trie : Trie[Int, Int] = Trie::new()
  let first = [1, 2, 3]
  let extended = [1, 2, 3, 4, 5]
  trie.insert(first.copy(), 1)
  assert_eq(trie.get(first.copy()), Some(1))
  trie.insert(extended.copy(), 2)
  assert_eq(trie.get(extended.copy()), Some(2))
  assert_eq(trie.get(first.copy()), Some(1))
  let other = [10, 20, 30]
  trie.insert(other.copy(), 3)
  assert_eq(trie.get(other.copy()), Some(3))
  let missing = [4, 5, 6]
  assert_eq(trie.get(missing), None)
  let longer = [1, 2, 3, 4, 5, 6]
  assert_eq(trie.get(longer), None)
}

///|
test "empty trie behavior" {
  let trie : Trie[Char, Int] = Trie::new()
  let foo = ['f', 'o', 'o']
  assert_eq(trie.get(foo), None)
  let empty : Array[Char] = Array::new()
  assert_eq(trie.get(empty.copy()), None)
  assert_eq(trie.is_empty(), true)
}

///|
test "insert empty key" {
  let trie : Trie[Char, Int] = Trie::new()
  let empty : Array[Char] = Array::new()
  trie.insert(empty.copy(), 42)
  assert_eq(trie.get(empty.copy()), Some(42))
  let foo = ['f', 'o', 'o']
  assert_eq(trie.get(foo), None)
  assert_eq(trie.is_empty(), false)
}

///|
test "overlapping keys" {
  let trie : Trie[Char, Int] = Trie::new()
  let car = ['c', 'a', 'r']
  let cart = ['c', 'a', 'r', 't']
  let carter = ['c', 'a', 'r', 't', 'e', 'r']
  trie.insert(car.copy(), 1)
  trie.insert(cart.copy(), 2)
  trie.insert(carter.copy(), 3)
  assert_eq(trie.get(car.copy()), Some(1))
  assert_eq(trie.get(cart.copy()), Some(2))
  assert_eq(trie.get(carter.copy()), Some(3))
  let care = ['c', 'a', 'r', 'e']
  assert_eq(trie.get(care), None)
}

///|
test "partial matches do not return values" {
  let trie : Trie[Char, Int] = Trie::new()
  let apple = ['a', 'p', 'p', 'l', 'e']
  trie.insert(apple.copy(), 10)
  let app = ['a', 'p', 'p']
  let appl = ['a', 'p', 'p', 'l']
  let applepie = ['a', 'p', 'p', 'l', 'e', 'p', 'i', 'e']
  assert_eq(trie.get(app), None)
  assert_eq(trie.get(appl), None)
  assert_eq(trie.get(apple.copy()), Some(10))
  assert_eq(trie.get(applepie), None)
}

///|
test "clear removes all keys" {
  let trie : Trie[Char, Int] = Trie::new()
  let foo = ['f', 'o', 'o']
  trie.insert(foo.copy(), 1)
  assert_eq(trie.is_empty(), false)
  trie.clear()
  assert_eq(trie.get(foo), None)
  assert_eq(trie.is_empty(), true)
}
