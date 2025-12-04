///|
let default_alphabet_size : Int = 512

///|
struct ACNode {
  next : Array[Int]
  mut fail : Int
  mut output : Array[Int]
}

///|
fn ACNode::new(alphabet_size : Int) -> ACNode {
  ACNode::{
    next: Array::make(alphabet_size, -1),
    fail: 0,
    output: Array::new(),
  }
}

///|
pub struct ACMatch {
  start : Int
  end : Int
  pattern_index : Int
}

///|
pub fn ACMatch::start(self : ACMatch) -> Int {
  self.start
}

///|
pub fn ACMatch::end(self : ACMatch) -> Int {
  self.end
}

///|
pub fn ACMatch::pattern_index(self : ACMatch) -> Int {
  self.pattern_index
}

///|
pub struct ACAutomaton {
  nodes : Array[ACNode]
  alphabet_size : Int
  pattern_lengths : Array[Int]
  mut built : Bool
}

///|
pub fn ACAutomaton::new(
  alphabet_size? : Int = default_alphabet_size,
) -> ACAutomaton {
  let nodes : Array[ACNode] = []
  nodes.push(ACNode::new(alphabet_size))
  ACAutomaton::{
    nodes,
    alphabet_size,
    pattern_lengths: Array::new(),
    built: false,
  }
}

///|
/// Insert a pattern into the automaton and return its identifier.
///
/// # Parameters
///
/// - `pattern` : pattern string to insert.
///
/// # Returns
///
/// - `Int` : identifier that can be used to identify matches of this pattern.
pub fn ACAutomaton::add_pattern(self : ACAutomaton, pattern : String) -> Int {
  let mut state = 0
  for i = 0; i < pattern.length(); i = i + 1 {
    let idx = pattern.code_unit_at(i).to_byte().to_int()
    let node = self.nodes[state]
    if node.next[idx] == -1 {
      self.nodes.push(ACNode::new(self.alphabet_size))
      let next_index = self.nodes.length() - 1
      node.next[idx] = next_index
    }
    let next_state = node.next[idx]
    self.nodes[state] = node
    state = next_state
  }
  let id = self.pattern_lengths.length()
  self.pattern_lengths.push(pattern.length())
  let node = self.nodes[state]
  node.output.push(id)
  self.nodes[state] = node
  self.built = false
  id
}

///|
/// Build the failure links of the automaton. This is automatically invoked by
/// `query`, but can be called manually after bulk insertions.
pub fn ACAutomaton::build(self : ACAutomaton) -> Unit {
  if self.built {
    return
  }
  let queue : Array[Int] = []
  for c = 0; c < self.alphabet_size; c = c + 1 {
    let next_state = self.nodes[0].next[c]
    if next_state != -1 {
      self.nodes[next_state].fail = 0
      queue.push(next_state)
    }
  }
  let mut head = 0
  while head < queue.length() {
    let state = queue[head]
    head = head + 1
    for c = 0; c < self.alphabet_size; c = c + 1 {
      let next_state = self.nodes[state].next[c]
      if next_state != -1 {
        let mut f = self.nodes[state].fail
        while f > 0 && self.nodes[f].next[c] == -1 {
          f = self.nodes[f].fail
        }
        if self.nodes[f].next[c] != -1 {
          f = self.nodes[f].next[c]
        }
        self.nodes[next_state].fail = f
        let outs = self.nodes[f].output
        if outs.length() > 0 {
          let child_out = self.nodes[next_state].output
          for i = 0; i < outs.length(); i = i + 1 {
            let pid = outs[i]
            let mut dup = false
            for j = 0; j < child_out.length(); j = j + 1 {
              if child_out[j] == pid {
                dup = true
                break
              }
            }
            if !dup {
              child_out.push(pid)
            }
          }
          self.nodes[next_state].output = child_out
        }
        queue.push(next_state)
      }
    }
  }
  self.built = true
}

///|
/// Query the automaton against the provided text, returning all matches found.
///
/// # Parameters
///
/// - `text` : the text to scan for inserted patterns.
///
/// # Returns
///
/// - `Array[ACMatch]` : all matches, ordered by their ending position.
pub fn ACAutomaton::query(self : ACAutomaton, text : String) -> Array[ACMatch] {
  if !self.built {
    self.build()
  }
  let mut state = 0
  let matches : Array[ACMatch] = []
  for i = 0; i < text.length(); i = i + 1 {
    let idx = text.code_unit_at(i).to_byte().to_int()
    let mut s = state
    while s > 0 && self.nodes[s].next[idx] == -1 {
      s = self.nodes[s].fail
    }
    if self.nodes[s].next[idx] != -1 {
      s = self.nodes[s].next[idx]
    }
    state = s
    let node = self.nodes[state]
    for j = 0; j < node.output.length(); j = j + 1 {
      let pid = node.output[j]
      let len = self.pattern_lengths[pid]
      let start = i - len + 1
      matches.push(ACMatch::{ start, end: i, pattern_index: pid })
    }
  }
  matches
}

///|
/// Get the number of patterns stored in the automaton.
pub fn ACAutomaton::pattern_count(self : ACAutomaton) -> Int {
  self.pattern_lengths.length()
}

///|
/// Clear all stored patterns and reset the automaton to its initial state.
pub fn ACAutomaton::clear(self : ACAutomaton) -> Unit {
  self.nodes.clear()
  self.nodes.push(ACNode::new(self.alphabet_size))
  self.pattern_lengths.clear()
  self.built = false
}
