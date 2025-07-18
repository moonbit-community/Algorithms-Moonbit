///|
pub(all) struct AVLTree {
  val : Int
  height : Int
  left : AVLTree?
  right : AVLTree?
}

///|
pub fn new(val : Int) -> AVLTree {
  AVLTree::{ val, height: 0, left: None, right: None }
}

///|
pub fn height(node : AVLTree?) -> Int {
  match node {
    Some(n) => n.height
    None => -1
  }
}

///|
pub fn max(a : Int, b : Int) -> Int {
  if a > b {
    a
  } else {
    b
  }
}

///|
pub fn update_height(node : AVLTree) -> AVLTree {
  AVLTree::{
    val: node.val,
    height: max(height(node.left), height(node.right)) + 1,
    left: node.left,
    right: node.right,
  }
}

///|
pub fn balance_factor(node : AVLTree) -> Int {
  height(node.left) - height(node.right)
}

///|
pub fn right_rotate(node : AVLTree) -> AVLTree {
  match node.left {
    Some(child) => {
      let grand_child = child.right
      // Create new rotated nodes
      let new_node = AVLTree::{
        val: node.val,
        height: node.height,
        left: grand_child,
        right: node.right,
      }
      let new_child = AVLTree::{
        val: child.val,
        height: child.height,
        left: child.left,
        right: Some(new_node),
      }
      // Update heights
      let updated_node = update_height(new_node)
      update_height(AVLTree::{
        val: new_child.val,
        height: new_child.height,
        left: new_child.left,
        right: Some(updated_node),
      })
    }
    None => node // Can't rotate right if no left child
  }
}

///|
pub fn left_rotate(node : AVLTree) -> AVLTree {
  match node.right {
    Some(child) => {
      let grand_child = child.left
      // Create new rotated nodes
      let new_node = AVLTree::{
        val: node.val,
        height: node.height,
        left: node.left,
        right: grand_child,
      }
      let new_child = AVLTree::{
        val: child.val,
        height: child.height,
        left: Some(new_node),
        right: child.right,
      }
      // Update heights
      let updated_node = update_height(new_node)
      update_height(AVLTree::{
        val: new_child.val,
        height: new_child.height,
        left: Some(updated_node),
        right: new_child.right,
      })
    }
    None => node // Can't rotate left if no right child
  }
}

///|
pub fn rotate(node : AVLTree) -> AVLTree {
  let bf = balance_factor(node)
  // Left-heavy tree
  if bf > 1 {
    match node.left {
      Some(left) =>
        if balance_factor(left) >= 0 {
          right_rotate(node)
        } else {
          let rotated_left = left_rotate(left)
          let new_node = AVLTree::{
            val: node.val,
            height: node.height,
            left: Some(rotated_left),
            right: node.right,
          }
          right_rotate(new_node)
        }
      None => node
    }
    // Right-heavy tree
  } else if bf < -1 {
    match node.right {
      Some(right) =>
        if balance_factor(right) <= 0 {
          left_rotate(node)
        } else {
          let rotated_right = right_rotate(right)
          let new_node = AVLTree::{
            val: node.val,
            height: node.height,
            left: node.left,
            right: Some(rotated_right),
          }
          left_rotate(new_node)
        }
      None => node
    }
  } else {
    node
  }
}

///|
pub fn insert(node : AVLTree?, val : Int) -> AVLTree? {
  match node {
    Some(n) => {
      // 1. Insert node
      let new_node = if val < n.val {
        AVLTree::{
          val: n.val,
          height: n.height,
          left: insert(n.left, val),
          right: n.right,
        }
      } else if val > n.val {
        AVLTree::{
          val: n.val,
          height: n.height,
          left: n.left,
          right: insert(n.right, val),
        }
      } else {
        n // Duplicate, return unchanged
      }

      // 2. Update height and rebalance
      let updated = update_height(new_node)
      Some(rotate(updated))
    }
    None => Some(new(val))
  }
}

///|
pub fn remove(node : AVLTree?, val : Int) -> AVLTree? {
  match node {
    Some(n) =>
      // 1. Find and remove node
      if val < n.val {
        let new_left = remove(n.left, val)
        let updated = update_height(AVLTree::{
          val: n.val,
          height: n.height,
          left: new_left,
          right: n.right,
        })
        Some(rotate(updated))
      } else if val > n.val {
        let new_right = remove(n.right, val)
        let updated = update_height(AVLTree::{
          val: n.val,
          height: n.height,
          left: n.left,
          right: new_right,
        })
        Some(rotate(updated))
      } else {
        // Handle node removal
        match (n.left, n.right) {
          (None, None) => None
          (Some(left), None) => Some(left)
          (None, Some(right)) => Some(right)
          (Some(_), Some(right)) => {
            // Node has 2 children
            let mut temp = right
            while true {
              match temp.left {
                Some(left) => temp = left
                None => break
              }
            }
            let new_right = remove(n.right, temp.val)
            let updated = update_height(AVLTree::{
              val: temp.val,
              height: n.height,
              left: n.left,
              right: new_right,
            })
            Some(rotate(updated))
          }
        }
      }
    None => None
  }
}
