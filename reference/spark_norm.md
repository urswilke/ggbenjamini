# Manipulate the angles of the leaves with a normal distribution

This function returns a function which itself returns a numerical vector
of length of the number of leaves on the branch.

## Usage

``` r
spark_norm(mean = 0, sd = 3)
```

## Arguments

- mean, sd:

  Parameters passed to
  [`stats::dnorm()`](https://rdrr.io/r/stats/Normal.html).

## Value

dnorm() function with n_leaves as one of the arguments

## Examples

``` r
spark_norm()
#> function (n_leaves) 
#> {
#>     stats::rnorm(n_leaves, mean = mean, sd = sd)
#> }
#> <bytecode: 0x55756d3b1420>
#> <environment: 0x557576c83648>
```
