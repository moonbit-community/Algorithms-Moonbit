# Manacher's Algorithm

## Functions

### manacher

Finds the length of the longest palindromic substring in the given string using Manacher's Algorithm.

#### Parameters

- `str` : Input string.

#### Returns

- `Int` : Length of the longest palindromic substring.

#### Example

```moonbit
test "manacher" {
  let s = "babad"
  inspect!(manacher(s), content="3") // "bab" or "aba"
  
  let s2 = "cbbd"
  inspect!(manacher(s2), content="2") // "bb"
}
```
