# Algorithm-Lib-Moonbit

## Inverse Pair Algorithm

This library provides an implementation of the inverse pair algorithm, which is used to count the number of inverse pairs in an array. An inverse pair is a pair of elements in an array where the first element is greater than the second element and the first element appears before the second element.

### Usage

To use the inverse pair algorithm, you can call the `inverse_pair` function with an array as the parameter. The function will return the number of inverse pairs in the array.

#### Parameters

- `arr`: The array to find inverse pairs.

#### Returns

- `Int`: The number of inverse pairs in the array.

### Example

```moonbit
test {
  let arr = [2, 4, 1, 3, 5]
  inspect!(inverse_pair(arr), content="3")
  let arr2 = [5, 4, 3, 2, 1]
  inspect!(inverse_pair(arr2), content="10")
}
```

In the example above, the `inverse_pair` function is called with two different arrays. The first array `[2, 4, 1, 3, 5]` has 3 inverse pairs, and the second array `[5, 4, 3, 2, 1]` has 10 inverse pairs.