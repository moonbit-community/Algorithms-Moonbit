///|
enum Color {
  Red
  Black
} derive(Eq)

///|
struct Node[K, V] {
  mut key : K
  mut value : V
  mut color : Color
  mut left : Node[K, V]?
  mut right : Node[K, V]?
} derive(Eq)

///|
fn[K, V] Node::new(key : K, value : V) -> Node[K, V] {
  Node::{ key, value, color: Color::Red, left: None, right: None }
}

///|
fn flip_color(color : Color) -> Color {
  match color {
    Red => Black
    Black => Red
  }
}

///|
fn[K, V] is_red(node_opt : Node[K, V]?) -> Bool {
  match node_opt {
    Some(node) => node.color == Color::Red
    None => false
  }
}

///|
fn[K, V] rotate_left(node_value : Node[K, V]) -> Node[K, V] {
  match node_value.right {
    Some(right_value) => {
      let node = node_value
      let right = right_value
      node.right = right.left
      right.left = Some(node)
      right.color = node.color
      node.color = Color::Red
      right
    }
    None => node_value
  }
}

///|
fn[K, V] rotate_right(node_value : Node[K, V]) -> Node[K, V] {
  match node_value.left {
    Some(left_value) => {
      let node = node_value
      let left = left_value
      node.left = left.right
      left.right = Some(node)
      left.color = node.color
      node.color = Color::Red
      left
    }
    None => node_value
  }
}

///|
fn[K, V] flip_colors(node_value : Node[K, V]) -> Node[K, V] {
  let node = node_value
  node.color = flip_color(node.color)
  match node.left {
    Some(left_value) => {
      let left = left_value
      left.color = flip_color(left.color)
      node.left = Some(left)
    }
    None => ()
  }
  match node.right {
    Some(right_value) => {
      let right = right_value
      right.color = flip_color(right.color)
      node.right = Some(right)
    }
    None => ()
  }
  node
}

///|
fn[K, V] fix_up(node_value : Node[K, V]) -> Node[K, V] {
  let mut node = node_value
  if is_red(node.right) && !is_red(node.left) {
    node = rotate_left(node)
  }
  match node.left {
    Some(left_value) => if is_red(left_value.left) { node = rotate_right(node) }
    None => ()
  }
  if is_red(node.left) && is_red(node.right) {
    node = flip_colors(node)
  }
  node
}

///|
fn[K, V] move_red_left(node_value : Node[K, V]) -> Node[K, V] {
  let mut node = flip_colors(node_value)
  match node.right {
    Some(right_value) =>
      if is_red(right_value.left) {
        let rotated_right = rotate_right(right_value)
        node.right = Some(rotated_right)
        node = rotate_left(node)
        node = flip_colors(node)
      }
    None => ()
  }
  node
}

///|
fn[K, V] move_red_right(node_value : Node[K, V]) -> Node[K, V] {
  let mut node = flip_colors(node_value)
  match node.left {
    Some(left_value) =>
      if is_red(left_value.left) {
        node = rotate_right(node)
        node = flip_colors(node)
      }
    None => ()
  }
  node
}

///|
fn[K, V] min_node(node_opt : Node[K, V]?) -> Node[K, V]? {
  match node_opt {
    None => None
    Some(node_value) => {
      let node = node_value
      match node.left {
        None => Some(node)
        Some(_) => min_node(node.left)
      }
    }
  }
}

///|
fn[K, V] remove_min(node_opt : Node[K, V]?) -> Node[K, V]? {
  match node_opt {
    None => None
    Some(node_value) => {
      let mut node = node_value
      match node.left {
        None => None
        Some(_) => {
          if !is_red(node.left) {
            match node.left {
              Some(left_value) =>
                if !is_red(left_value.left) {
                  node = move_red_left(node)
                }
              None => ()
            }
          }
          node.left = remove_min(node.left)
          Some(fix_up(node))
        }
      }
    }
  }
}

///|
fn[K : Compare, V] insert_node(
  node_opt : Node[K, V]?,
  key : K,
  value : V,
) -> (Node[K, V]?, Bool) {
  match node_opt {
    None => (Some(Node::new(key, value)), true)
    Some(node_value) => {
      let mut node = node_value
      let cmp = key.compare(node.key)
      let mut inserted = false
      if cmp < 0 {
        let (new_left, did_insert) = insert_node(node.left, key, value)
        node.left = new_left
        inserted = did_insert
      } else if cmp > 0 {
        let (new_right, did_insert) = insert_node(node.right, key, value)
        node.right = new_right
        inserted = did_insert
      } else {
        node.value = value
      }
      node = fix_up(node)
      (Some(node), inserted)
    }
  }
}

///|
fn[K : Compare, V : Eq] delete_node(
  node_opt : Node[K, V]?,
  key : K,
) -> (Node[K, V]?, Bool) {
  match node_opt {
    None => (None, false)
    Some(node_value) => {
      let mut node = node_value
      let mut removed = false
      if key.compare(node.key) < 0 {
        match node.left {
          None => return (Some(node), false)
          Some(_) => {
            if !is_red(node.left) {
              match node.left {
                Some(left_value) =>
                  if !is_red(left_value.left) {
                    node = move_red_left(node)
                  }
                None => ()
              }
            }
            let (new_left, removed_left) = delete_node(node.left, key)
            node.left = new_left
            removed = removed_left
          }
        }
      } else {
        if is_red(node.left) {
          node = rotate_right(node)
        }
        if key.compare(node.key) == 0 && node.right == None {
          return (None, true)
        }
        match node.right {
          None => return (Some(node), false)
          Some(_) => {
            if !is_red(node.right) {
              match node.right {
                Some(right_value) =>
                  if !is_red(right_value.left) {
                    node = move_red_right(node)
                  }
                None => ()
              }
            }
            if key.compare(node.key) == 0 {
              match min_node(node.right) {
                Some(successor_value) => {
                  let successor = successor_value
                  node.key = successor.key
                  node.value = successor.value
                  node.right = remove_min(node.right)
                  removed = true
                }
                None => removed = false
              }
            } else {
              let (new_right, removed_right) = delete_node(node.right, key)
              node.right = new_right
              removed = removed_right
            }
          }
        }
      }
      (Some(fix_up(node)), removed)
    }
  }
}

///|
fn[K : Compare, V] find_node(node_opt : Node[K, V]?, key : K) -> V? {
  match node_opt {
    None => None
    Some(node_value) => {
      let node = node_value
      let cmp = key.compare(node.key)
      if cmp == 0 {
        Some(node.value)
      } else if cmp < 0 {
        find_node(node.left, key)
      } else {
        find_node(node.right, key)
      }
    }
  }
}

///|
pub struct RedBlackTree[K, V] {
  mut root : Node[K, V]?
  mut size : Int
}

///|
pub fn[K, V] RedBlackTree::new() -> RedBlackTree[K, V] {
  RedBlackTree::{ root: None, size: 0 }
}

///|
pub fn[K, V] RedBlackTree::len(self : RedBlackTree[K, V]) -> Int {
  self.size
}

///|
pub fn[K, V] RedBlackTree::is_empty(self : RedBlackTree[K, V]) -> Bool {
  self.size == 0
}

///|
pub fn[K, V] RedBlackTree::clear(self : RedBlackTree[K, V]) -> Unit {
  self.root = None
  self.size = 0
}

///|
pub fn[K : Compare, V] RedBlackTree::insert(
  self : RedBlackTree[K, V],
  key : K,
  value : V,
) -> Unit {
  let (new_root, inserted) = insert_node(self.root, key, value)
  match new_root {
    None => self.root = None
    Some(root_value) => {
      let root = root_value
      root.color = Color::Black
      self.root = Some(root)
    }
  }
  if inserted {
    self.size = self.size + 1
  }
}

///|
pub fn[K : Compare, V] RedBlackTree::get(
  self : RedBlackTree[K, V],
  key : K,
) -> V? {
  find_node(self.root, key)
}

///|
pub fn[K : Compare, V] RedBlackTree::contains(
  self : RedBlackTree[K, V],
  key : K,
) -> Bool {
  match self.get(key) {
    Some(_) => true
    None => false
  }
}

///|
pub fn[K : Compare, V : Eq] RedBlackTree::remove(
  self : RedBlackTree[K, V],
  key : K,
) -> Bool {
  if self.root == None {
    return false
  }
  let (new_root, removed) = delete_node(self.root, key)
  match new_root {
    None => self.root = None
    Some(root_value) => {
      let root = root_value
      root.color = Color::Black
      self.root = Some(root)
    }
  }
  if removed {
    self.size = self.size - 1
  }
  removed
}

///|
pub impl[K, V] Default for RedBlackTree[K, V] with default() {
  RedBlackTree::new()
}
