///|
test "AVLTree::balance_factor" {
  let tree = new(10)
  let tree = insert(Some(tree), 5).unwrap()
  inspect(balance_factor(tree), content="1")
  let tree = insert(Some(tree), 15).unwrap()
  inspect(balance_factor(tree), content="0")
}

///|
test "AVLTree::rotation" {
  // Test left rotation
  let tree = new(10)
  let tree = insert(Some(tree), 15).unwrap()
  let tree = insert(Some(tree), 20).unwrap()
  inspect(tree.val, content="15")
  inspect(tree.left.unwrap().val, content="10")
  inspect(tree.right.unwrap().val, content="20")

  // Test right rotation
  let tree = new(10)
  let tree = insert(Some(tree), 5).unwrap()
  let tree = insert(Some(tree), 2).unwrap()
  inspect(tree.val, content="5")
  inspect(tree.left.unwrap().val, content="2")
  inspect(tree.right.unwrap().val, content="10")

  // Test left-right rotation
  let tree = new(10)
  let tree = insert(Some(tree), 5).unwrap()
  let tree = insert(Some(tree), 7).unwrap()
  inspect(tree.val, content="7")
  inspect(tree.left.unwrap().val, content="5")
  inspect(tree.right.unwrap().val, content="10")

  // Test right-left rotation
  let tree = new(10)
  let tree = insert(Some(tree), 15).unwrap()
  let tree = insert(Some(tree), 12).unwrap()
  inspect(tree.val, content="12")
  inspect(tree.left.unwrap().val, content="10")
  inspect(tree.right.unwrap().val, content="15")
}

///|
test "AVLTree::remove" {
  let tree = new(10)
  let tree = insert(Some(tree), 5).unwrap()
  let tree = insert(Some(tree), 15).unwrap()
  let tree = insert(Some(tree), 3).unwrap()
  let tree = insert(Some(tree), 7).unwrap()
  let tree = insert(Some(tree), 12).unwrap()
  let tree = insert(Some(tree), 18).unwrap()

  // Remove node with one child
  let tree = remove(Some(tree), 5).unwrap()
  inspect(tree.left.unwrap().val, content="7")

  // Remove node with two children
  let tree = remove(Some(tree), 15).unwrap()
  inspect(tree.right.unwrap().val, content="18")
  inspect(tree.right.unwrap().left.unwrap().val, content="12")
}

///|
test "AVLTree::height" {
  let tree = new(10)
  inspect(height(Some(tree)), content="0")
  let tree = insert(Some(tree), 5).unwrap()
  inspect(height(Some(tree)), content="1")
  let tree = insert(Some(tree), 15).unwrap()
  inspect(height(Some(tree)), content="1")
  let tree = insert(Some(tree), 3).unwrap()
  inspect(height(Some(tree)), content="2")
}

///|
test "AVLTree::complex_insert" {
  let tree = new(30)
  let tree = insert(Some(tree), 20).unwrap()
  let tree = insert(Some(tree), 40).unwrap()
  let tree = insert(Some(tree), 10).unwrap()
  let tree = insert(Some(tree), 25).unwrap()
  let tree = insert(Some(tree), 35).unwrap()
  let tree = insert(Some(tree), 50).unwrap()
  let tree = insert(Some(tree), 5).unwrap()
  let tree = insert(Some(tree), 15).unwrap()
  let tree = insert(Some(tree), 45).unwrap()
  let tree = insert(Some(tree), 60).unwrap()
  inspect(tree.val, content="30")
  inspect(tree.left.unwrap().val, content="20")
  inspect(tree.right.unwrap().val, content="40")
  inspect(balance_factor(tree), content="0")
}
