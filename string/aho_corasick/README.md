# Aho-Corasick Automaton

## Structures

### ACAutomaton

A multi-pattern string matching automaton supporting efficient insertion and querying of patterns over a fixed-size alphabet.

### ACMatch

Represents a single match reported by the automaton. Stores the start and end positions (0-indexed) in the text together with the identifier of the matched pattern.

## Functions

### ACAutomaton::new

Creates a new automaton. Accepts an optional alphabet size parameter (default `256`, sufficient for ASCII inputs).

### ACAutomaton::add_pattern

Inserts a pattern string into the automaton and returns its identifier.

### ACAutomaton::build

Constructs failure links for the current set of patterns. This is invoked automatically by `query` when needed.

### ACAutomaton::query

Runs the automaton on a given text and returns all matches as an array of `ACMatch` values.

### ACAutomaton::pattern_count

Returns the number of patterns stored in the automaton.

### ACAutomaton::clear

Removes all patterns and resets the automaton to its initial state.

## Example

```moonbit
test "aho-corasick example" {
  let automaton = ACAutomaton::new()
  automaton.add_pattern("he")
  automaton.add_pattern("she")
  automaton.add_pattern("his")
  automaton.add_pattern("hers")
  let matches = automaton.query("ahishers")
  assert_eq(matches.length(), 4)
  assert_eq(matches[0].pattern_index(), 2)
  assert_eq(matches[0].start(), 1)
  assert_eq(matches[0].end(), 3)
}

