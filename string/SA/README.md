# Suffix Automaton

A suffix automaton (SAM) supporting incremental construction, substring queries, distinct substring counting, and longest common substring checks.

## Structures

### SuffixAutomaton
A mutable automaton storing states built from a source string. It can be extended one character at a time or rebuilt from an entire string.

## Functions

### SuffixAutomaton::new
Creates an empty automaton. Accepts an optional alphabet size (default `512`, suitable for ASCII inputs).

### SuffixAutomaton::extend
Extends the automaton with a single character while maintaining suffix links and transitions.

### SuffixAutomaton::build
Clears the automaton and rebuilds it from the provided string.

### SuffixAutomaton::contains
Checks whether a pattern appears as a substring in the built text.

### SuffixAutomaton::distinct_substring_count
Counts the number of distinct substrings represented by the automaton using the classic SAM formula.

### SuffixAutomaton::longest_common_substring_length
Computes the length of the longest common substring between the built text and another string.

## Example

```moonbit
test "suffix automaton example" {
  let sam = SuffixAutomaton::new()
  sam.build("ababa")
  assert(sam.contains("aba"))
  assert_eq(sam.distinct_substring_count(), 9)
  assert_eq(sam.longest_common_substring_length("cab"), 2)
}
