///|
///A Cartesian Tree is a binary tree derived from a sequence that simultaneously preserves
///the in-order traversal of the sequence and the heap property (this implementation uses a
///min-heap). It is particularly useful for range minimum queries, RMQ sparse table
///construction, and other applications where order and priority must be maintained together.
///
///This module provides a purely functional representation of a Cartesian Tree that keeps the
///original array values along with arrays describing the left child, right child, and parent
///relationship of each element.
///
pub struct CartesianTree[T] {
  values : Array[T]
  left : Array[Int?]
  right : Array[Int?]
  parent : Array[Int?]
  root : Int?
}

///|
///Builds a Cartesian Tree from the given array of values.
///
///The resulting tree satisfies two properties:
///
///- The in-order traversal of the tree equals the original array.
///- Every node is less than or equal to its children (min-heap property).
///
///# Parameters
///- `arr`: Source array whose order will be preserved in the in-order traversal.
///
///# Returns
///A new `CartesianTree` instance representing the hierarchy of the input sequence.
///
pub fn[T : Compare] CartesianTree::from_array(
  arr : Array[T],
) -> CartesianTree[T] {
  let values = arr
  let size = values.length()
  let left = Array::make(size, None)
  let right = Array::make(size, None)
  let parent = Array::make(size, None)
  let stack : Array[Int] = []
  for index in 0..<size {
    let mut last : Int? = None
    while stack.length() > 0 {
      let top_position = stack.length() - 1
      let top_index = stack[top_position]
      if values[index].compare(values[top_index]) < 0 {
        last = Some(stack.pop().unwrap())
      } else {
        break
      }
    }
    match last {
      Some(last_index) => {
        left[index] = Some(last_index)
        parent[last_index] = Some(index)
      }
      None => ()
    }
    if stack.length() > 0 {
      let parent_index = stack[stack.length() - 1]
      right[parent_index] = Some(index)
      parent[index] = Some(parent_index)
    }
    stack.push(index)
  }
  let mut root = None
  for i in 0..<size {
    match parent[i] {
      None => root = Some(i)
      Some(_) => ()
    }
  }
  CartesianTree::{ values, left, right, parent, root }
}

///|
///Returns the number of elements stored in the Cartesian Tree.
///
pub fn[T] CartesianTree::len(self : CartesianTree[T]) -> Int {
  self.values.length()
}

///|
///Checks whether the Cartesian Tree is empty.
///
pub fn[T] CartesianTree::is_empty(self : CartesianTree[T]) -> Bool {
  self.len() == 0
}

///|
///Returns the index of the root node within the original array, if the tree is not empty.
///
pub fn[T] CartesianTree::root_index(self : CartesianTree[T]) -> Int? {
  self.root
}

///|
///Returns the index of the left child for the node at the specified index, if it exists.
///
pub fn[T] CartesianTree::left_child(
  self : CartesianTree[T],
  index : Int,
) -> Int? {
  if index < 0 || index >= self.left.length() {
    None
  } else {
    self.left[index]
  }
}

///|
///Returns the index of the right child for the node at the specified index, if it exists.
///
pub fn[T] CartesianTree::right_child(
  self : CartesianTree[T],
  index : Int,
) -> Int? {
  if index < 0 || index >= self.right.length() {
    None
  } else {
    self.right[index]
  }
}

///|
///Returns the index of the parent for the node at the specified index, if it exists.
///
pub fn[T] CartesianTree::parent_index(
  self : CartesianTree[T],
  index : Int,
) -> Int? {
  if index < 0 || index >= self.parent.length() {
    None
  } else {
    self.parent[index]
  }
}

///|
///Retrieves the value stored at the specified index in the original array.
///
pub fn[T] CartesianTree::value_at(self : CartesianTree[T], index : Int) -> T? {
  if index < 0 || index >= self.values.length() {
    None
  } else {
    Some(self.values[index])
  }
}

///|
///Produces the in-order traversal of the Cartesian Tree.
///
pub fn[T] CartesianTree::inorder(self : CartesianTree[T]) -> Array[T] {
  let result : Array[T] = []
  match self.root {
    None => ()
    Some(root_index) => {
      let stack : Array[Int] = []
      let mut current : Int? = Some(root_index)
      while true {
        match current {
          Some(node_index) => {
            stack.push(node_index)
            current = self.left[node_index]
          }
          None => {
            if stack.length() == 0 {
              break
            }
            let node_index = stack.pop().unwrap()
            result.push(self.values[node_index])
            current = self.right[node_index]
          }
        }
      }
    }
  }
  result
}
