///|
let default_alphabet_size : Int = 512

///|
struct SANode {
  next : Array[Int]
  mut link : Int
  mut len : Int
}

///|
fn SANode::new(alphabet_size : Int) -> SANode {
  SANode::{ next: Array::make(alphabet_size, -1), link: -1, len: 0 }
}

///|
/// A Suffix Automaton that supports incremental construction and pattern queries.
pub struct SuffixAutomaton {
  nodes : Array[SANode]
  alphabet_size : Int
  mut last : Int
}

///|
pub fn SuffixAutomaton::new(
  alphabet_size? : Int = default_alphabet_size,
) -> SuffixAutomaton {
  let nodes : Array[SANode] = []
  nodes.push(SANode::new(alphabet_size))
  SuffixAutomaton::{ nodes, alphabet_size, last: 0 }
}

///|
/// Remove all states and reset the automaton to its initial state.
pub fn SuffixAutomaton::clear(self : SuffixAutomaton) -> Unit {
  self.nodes.clear()
  self.nodes.push(SANode::new(self.alphabet_size))
  self.last = 0
}

///|
/// Extend the automaton with a single character.
pub fn SuffixAutomaton::extend(self : SuffixAutomaton, ch : Char) -> Unit {
  let c = ch.to_int()
  let cur_index = self.nodes.length()
  let cur_node = SANode::new(self.alphabet_size)
  cur_node.len = self.nodes[self.last].len + 1
  self.nodes.push(cur_node)
  let mut p = self.last
  while p != -1 && self.nodes[p].next[c] == -1 {
    self.nodes[p].next[c] = cur_index
    p = self.nodes[p].link
  }
  if p == -1 {
    self.nodes[cur_index].link = 0
  } else {
    let q = self.nodes[p].next[c]
    if self.nodes[p].len + 1 == self.nodes[q].len {
      self.nodes[cur_index].link = q
    } else {
      let clone_node = self.nodes[q]
      clone_node.len = self.nodes[p].len + 1
      let clone_index = self.nodes.length()
      self.nodes.push(clone_node)
      while p != -1 && self.nodes[p].next[c] == q {
        self.nodes[p].next[c] = clone_index
        p = self.nodes[p].link
      }
      self.nodes[q].link = clone_index
      self.nodes[cur_index].link = clone_index
    }
  }
  self.last = cur_index
}

///|
/// Build an automaton for the provided string, replacing any previous content.
pub fn SuffixAutomaton::build(self : SuffixAutomaton, s : String) -> Unit {
  self.clear()
  for i = 0; i < s.length(); i = i + 1 {
    self.extend(s.code_unit_at(i).to_char().unwrap())
  }
}

///|
/// Check whether the automaton contains the given pattern as a substring.
pub fn SuffixAutomaton::contains(
  self : SuffixAutomaton,
  pattern : String,
) -> Bool {
  let mut state = 0
  for i = 0; i < pattern.length(); i = i + 1 {
    let c = pattern.code_unit_at(i).to_int()
    if self.nodes[state].next[c] == -1 {
      return false
    }
    state = self.nodes[state].next[c]
  }
  true
}

///|
/// Count the number of distinct substrings represented by the automaton.
pub fn SuffixAutomaton::distinct_substring_count(self : SuffixAutomaton) -> Int {
  let mut total = 0
  for i = 1; i < self.nodes.length(); i = i + 1 {
    let link = self.nodes[i].link
    if link >= 0 {
      total += self.nodes[i].len - self.nodes[link].len
    }
  }
  total
}

///|
/// Compute the length of the longest common substring between the built text and `text`.
pub fn SuffixAutomaton::longest_common_substring_length(
  self : SuffixAutomaton,
  text : String,
) -> Int {
  let mut state = 0
  let mut length = 0
  let mut best = 0
  for i = 0; i < text.length(); i = i + 1 {
    let c = text.code_unit_at(i).to_int()
    if self.nodes[state].next[c] != -1 {
      state = self.nodes[state].next[c]
      length = length + 1
    } else {
      while state != -1 && self.nodes[state].next[c] == -1 {
        state = self.nodes[state].link
      }
      if state == -1 {
        state = 0
        length = 0
      } else {
        length = self.nodes[state].len + 1
        state = self.nodes[state].next[c]
      }
    }
    if length > best {
      best = length
    }
  }
  best
}

///|
pub impl Default for SuffixAutomaton with default() {
  SuffixAutomaton::new()
}
