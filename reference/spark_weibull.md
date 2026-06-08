# Manipulate the sizes of the leaves with a Weibull distribution

This function returns a function which itself returns a numerical vector
of length `n_leaves`, the number of leaves on the branch. These values
serve as relative multiplication factors of the sizes of the leaves of
the branch. (The maximum value of this distribution is then normalized
to 1.)

## Usage

``` r
spark_weibull(shape = 1.2, scale_factor = 0.5)
```

## Arguments

- shape, scale_factor:

  Parameters passed to
  [`stats::dweibull()`](https://rdrr.io/r/stats/Weibull.html).

## Value

dweibull() function depending on n_leaves as one of the arguments

## Examples

``` r
#Mark the two consecutive pairs of parentheses:
spark_weibull()(n_leaves = 10)
#>  [1] 1.0000000 0.9517662 0.8377380 0.7097325 0.5867500 0.4765146 0.3816251
#>  [8] 0.3021437 0.2368941 0.1841649
```
