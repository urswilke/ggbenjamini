# Generate bezier curve coordinates of a benjamini leaf

Generate bezier curve coordinates of a benjamini leaf

## Usage

``` r
benjamini_leaf(
  leaf_params = gen_leaf_parameters(),
  omega = 0,
  xrot = leaf_params$x0,
  yrot = leaf_params$y0,
  precision = 2
)
```

## Arguments

- leaf_params:

  parameter that control the leaf shape

- omega:

  rotation angle of the leaf

- xrot:

  x coordinate of pivot point (preset to leaf origin).

- yrot:

  x coordinate of pivot point (preset to leaf origin).

- precision:

  numeric precision of the output

## Value

A dataframe conaining the data for the bezier curves of a leaf (see
example).

## Examples

``` r
df <- benjamini_leaf()
df
#> # A tibble: 36 × 5
#>    element i_part     x     y param_type            
#>    <chr>    <dbl> <dbl> <dbl> <chr>                 
#>  1 stalk        0  10    40   bezier start point    
#>  2 stalk        0  10.0  40.5 bezier control point 1
#>  3 stalk        0  21.0  39.6 bezier control point 2
#>  4 stalk        0  21    40   bezier end point      
#>  5 half 2       1  21    40   bezier start point    
#>  6 half 2       1  22    36   bezier control point 1
#>  7 half 2       1  34    29.8 bezier control point 2
#>  8 half 2       1  40    30   bezier end point      
#>  9 half 2       2  40    30   bezier start point    
#> 10 half 2       2  46    30.2 bezier control point 1
#> # ℹ 26 more rows
df %>%
  # This generated a unique identifier for the 4 rows of each bezier curve:
  tidyr::unite(b, element, i_part, remove = FALSE) %>%
  ggplot2::ggplot() +
  ggforce::geom_bezier(ggplot2::aes(x = x, y = y, group = b))
```
