# Fast Fourier Transform

This module provides an iterative Cooley–Tukey FFT for MoonBit along with a
ready-to-use polynomial convolution helper.

## Features

- Complex number helper struct for arithmetic inside the transform.
- `fft` function that performs forward and inverse transforms on power-of-two
  sized inputs.
- `convolution` helper for multiplying integer coefficient polynomials in
  \(O(n \log n)\).

## Example

```moonbit
let a = [1, 2, 3]
let b = [4, 5, 6]
let product = convolution(a, b)
inspect(product, content="[4, 13, 28, 27, 18]")

