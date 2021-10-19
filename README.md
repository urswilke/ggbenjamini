
<!-- README.md is generated from README.Rmd. Please edit that file -->

# benjaminileaves

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/benjaminileaves)](https://CRAN.R-project.org/package=benjaminileaves)
<!-- badges: end -->

## Generate benjamini leaves with bezier curves

The goal of this package is to generate shapes in the form of ficus
benjamina leaves ([weeping
fig](https://en.wikipedia.org/wiki/Ficus_benjamina)) with bezier curves.

## Installation

You can install the newest version of benjaminileaves from github with:

``` r
# install.packages("remotes")
# (if not installed yet)

remotes::install_github("urswilke/benjaminileaves")
```

## Usage

First load some libraries:

``` r
library(benjaminileaves)
library(purrr)
library(dplyr)
library(tidyr)
library(ggplot2)
set.seed(123)
```

## Illustration of the generated data

The package generates bezier curves that imitate the shape of the leaves
of a ficus benjamini. The main function is `benjamini_leaf()`:

``` r
df <- benjamini_leaf()
print(df, n = 40)
#> # A tibble: 36 × 5
#>    element i_part     x     y param_type            
#>    <chr>    <dbl> <dbl> <dbl> <chr>                 
#>  1 stalk        0  10    40   bezier start point    
#>  2 stalk        0  10.0  40.9 bezier control point 1
#>  3 stalk        0  20.0  39.4 bezier control point 2
#>  4 stalk        0  20    40   bezier end point      
#>  5 half 2       1  20    40   bezier start point    
#>  6 half 2       1  22    36   bezier control point 1
#>  7 half 2       1  29    35.2 bezier control point 2
#>  8 half 2       1  34    35   bezier end point      
#>  9 half 2       2  34    35   bezier start point    
#> 10 half 2       2  39    34.8 bezier control point 1
#> 11 half 2       2  43    37.3 bezier control point 2
#> 12 half 2       2  45    38.8 bezier end point      
#> 13 half 2       3  45    38.8 bezier start point    
#> 14 half 2       3  47    40.2 bezier control point 1
#> 15 half 2       3  51.0  39.4 bezier control point 2
#> 16 half 2       3  51    40   bezier end point      
#> 17 half 2       4  51    40   bezier start point    
#> 18 half 2       4  38    40.3 bezier control point 1
#> 19 half 2       4  33    39.6 bezier control point 2
#> 20 half 2       4  20    40   bezier end point      
#> 21 half 1       1  20    40   bezier start point    
#> 22 half 1       1  22    44   bezier control point 1
#> 23 half 1       1  29    44.8 bezier control point 2
#> 24 half 1       1  34    45   bezier end point      
#> 25 half 1       2  34    45   bezier start point    
#> 26 half 1       2  39    45.2 bezier control point 1
#> 27 half 1       2  43    42.7 bezier control point 2
#> 28 half 1       2  45    41.2 bezier end point      
#> 29 half 1       3  45    41.2 bezier start point    
#> 30 half 1       3  47    39.8 bezier control point 1
#> 31 half 1       3  51.0  40.6 bezier control point 2
#> 32 half 1       3  51    40   bezier end point      
#> 33 half 1       4  51    40   bezier start point    
#> 34 half 1       4  38    40.3 bezier control point 1
#> 35 half 1       4  33    39.6 bezier control point 2
#> 36 half 1       4  20    40   bezier end point
```

It results in a dataframe of multiple bezier curves representing the
shape of a leaf. The first column `element` indicates which part of the
leaf the bezier describes, and can take the values “stalk”, “half 2” and
“half 1”. `i_part` denotes the id of the bezier curve, and `x` & `y` its
point coordinates. The column `param_type` denotes the type of the point
in the bezier curve.

The meaning is best illustrated with a plot:

``` r
# rearrange data to display segments:
segments <- df %>% 
  select(-param_type) %>% 
  group_by(element, i_part) %>% 
  mutate(j = c(1, 2, 1, 2)) %>%
  ungroup() %>% 
  pivot_wider(
    names_from = j,
    values_from = c(x, y),
    values_fn = list
  ) %>% 
  unnest(c(x_1, x_2, y_1, y_2))



ggplot(df, aes(x = x, y = y)) + 
  geom_point(color = "red") +
  geom_point(data = df %>% group_by(element, i_part) %>% slice(c(1, 4)), color = "blue", size = 2) +
  geom_point(data = df %>% slice(1), color = "black", size = 3) +
  ggforce::geom_bezier(aes(group = interaction(element, i_part), color = factor(i_part))) +
  geom_segment(
    data = segments, 
    aes(
      x = x_1, 
      xend = x_2, 
      y = y_1, 
      yend = y_2
    ), 
    linetype = "dotted", 
    color = "red"
  ) +
  coord_equal() +
  theme_minimal()
```

<img src="man/figures/README-def-1.png" width="100%" />

The black point represents the leaf origin. This and the blue points
denote the start/end points of the bezier curves, and the red dots the
positions of the control points. The leaf is cut in two halves
(`element == "half 1" OR "half 2"`) by the lines where `i_part == 4`
(which represents the midvein of the leaf). The exact dimensions of
these coordinates are generated by random numbers in certain ranges (see
the definition of the argument `leaf_params` in `benjamini_leaf()`).

## Illustration of the randomness

In order to show the variations of the `benjamini_leaf()` (if parameters
are not explicitly specified), let’s only pass the position of the leaf
origins and let the function randomly generate the rest of the shapes:

``` r
dfb <- expand_grid(
    x = seq(0, 200, 50),
    y = seq(25, 125, 25)
) %>%
  transpose() %>%
  map_dfr(~benjamini_leaf(gen_leaf_parameters(x0 = .x$x, y0 = .x$y)), .id = "i_leaf") %>%
  unite(i, i_leaf, i_part, element, remove = FALSE)

ggplot(dfb) +
  ggforce::geom_bezier(aes(x = x, y = y, group = i)) +
  # geom_point(data = l_points %>% bind_rows(), aes(x = x, y = y), color = "red") +
  coord_equal() +
  theme_minimal()
```

<img src="man/figures/README-plotlotsofbenjamini-1.png" width="100%" />
