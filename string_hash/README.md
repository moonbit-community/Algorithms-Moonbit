# string hash
It provides an example of a string hashing algorithm based on polynomial rolling hash.

## Usage

To use the `StringHash` class, follow these steps:

1. Create a new `StringHash` object by passing the string you want to hash.
2. Use the `get_hash` method to get the hash value of a substring.

### Example

```moonbit
let hash = StringHash::new("abc")
inspect!(hash.get_hash(0, 1), content="133") // hash of "ab"
```