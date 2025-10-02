///|
struct Node[K, V] {
  key : K
  mut value : V
  mut left : Node[K, V]?
  mut right : Node[K, V]?
}

///|
fn[K, V] Node::new(key : K, value : V) -> Node[K, V] {
  Node::{ key, value, left: None, right: None }
}

///|
fn[K, V] rotate_right(node_value : Node[K, V]) -> Node[K, V] {
  match node_value.left {
    Some(left_value) => {
      let parent = node_value
      let child = left_value
      parent.left = child.right
      child.right = Some(parent)
      child
    }
    None => node_value
  }
}

///|
fn[K, V] rotate_left(node_value : Node[K, V]) -> Node[K, V] {
  match node_value.right {
    Some(right_value) => {
      let parent = node_value
      let child = right_value
      parent.right = child.left
      child.left = Some(parent)
      child
    }
    None => node_value
  }
}

///|
fn[K : Compare, V] splay(root : Node[K, V]?, key : K) -> Node[K, V]? {
  match root {
    None => None
    Some(node_value) => {
      let node = node_value
      let cmp_root = key.compare(node.key)
      if cmp_root < 0 {
        match node.left {
          None => Some(node)
          Some(left_value) => {
            let left_child = left_value
            let cmp_left = key.compare(left_child.key)
            if cmp_left < 0 {
              left_child.left = splay(left_child.left, key)
              node.left = Some(left_child)
              Some(rotate_right(rotate_right(node)))
            } else if cmp_left > 0 {
              left_child.right = splay(left_child.right, key)
              let rotated = rotate_left(left_child)
              node.left = Some(rotated)
              Some(rotate_right(node))
            } else {
              node.left = Some(left_child)
              Some(rotate_right(node))
            }
          }
        }
      } else if cmp_root > 0 {
        match node.right {
          None => Some(node)
          Some(right_value) => {
            let right_child = right_value
            let cmp_right = key.compare(right_child.key)
            if cmp_right > 0 {
              right_child.right = splay(right_child.right, key)
              node.right = Some(right_child)
              Some(rotate_left(rotate_left(node)))
            } else if cmp_right < 0 {
              right_child.left = splay(right_child.left, key)
              let rotated = rotate_right(right_child)
              node.right = Some(rotated)
              Some(rotate_left(node))
            } else {
              node.right = Some(right_child)
              Some(rotate_left(node))
            }
          }
        }
      } else {
        Some(node)
      }
    }
  }
}

///|
pub struct SplayTree[K, V] {
  mut root : Node[K, V]?
  mut size : Int
}

///|
pub fn[K, V] SplayTree::new() -> SplayTree[K, V] {
  SplayTree::{ root: None, size: 0 }
}

///|
pub fn[K, V] len(self : SplayTree[K, V]) -> Int {
  self.size
}

///|
pub fn[K, V] is_empty(self : SplayTree[K, V]) -> Bool {
  self.size == 0
}

///|
pub fn[K, V] clear(self : SplayTree[K, V]) -> Unit {
  self.root = None
  self.size = 0
}

///|
pub fn[K : Compare, V] SplayTree::insert(
  self : SplayTree[K, V],
  key : K,
  value : V,
) -> Unit {
  let splayed = splay(self.root, key)
  match splayed {
    None => {
      self.root = Some(Node::new(key, value))
      self.size = self.size + 1
    }
    Some(root_value) => {
      let root = root_value
      let cmp = key.compare(root.key)
      if cmp == 0 {
        root.value = value
        self.root = Some(root)
      } else if cmp < 0 {
        let left_sub = root.left
        root.left = None
        let new_root = Node::{ key, value, left: left_sub, right: Some(root) }
        self.root = Some(new_root)
        self.size = self.size + 1
      } else {
        let right_sub = root.right
        root.right = None
        let new_root = Node::{ key, value, left: Some(root), right: right_sub }
        self.root = Some(new_root)
        self.size = self.size + 1
      }
    }
  }
}

///|
pub fn[K : Compare, V] SplayTree::get(self : SplayTree[K, V], key : K) -> V? {
  self.root = splay(self.root, key)
  match self.root {
    Some(root) =>
      if key.compare(root.key) == 0 {
        Some(root.value)
      } else {
        None
      }
    None => None
  }
}

///|
pub fn[K : Compare, V] SplayTree::contains(
  self : SplayTree[K, V],
  key : K,
) -> Bool {
  match self.get(key) {
    Some(_) => true
    None => false
  }
}

///|
pub fn[K : Compare, V] SplayTree::remove(
  self : SplayTree[K, V],
  key : K,
) -> Bool {
  if self.size == 0 {
    return false
  }
  self.root = splay(self.root, key)
  match self.root {
    Some(root_value) => {
      let root = root_value
      if key.compare(root.key) != 0 {
        self.root = Some(root)
        false
      } else {
        let left_sub = root.left
        let right_sub = root.right
        root.left = None
        root.right = None
        self.size = self.size - 1
        match left_sub {
          None => self.root = right_sub
          Some(left_root_value) => {
            let new_root = splay(Some(left_root_value), key)
            match new_root {
              Some(left_root_node) => {
                let left_root = left_root_node
                left_root.right = right_sub
                self.root = Some(left_root)
              }
              None => self.root = right_sub
            }
          }
        }
        true
      }
    }
    None => false
  }
}

///|
pub impl[K, V] Default for SplayTree[K, V] with default() {
  SplayTree::new()
}
