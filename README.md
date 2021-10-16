
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
To demonstrate it we’ll first load some packages:

## Installation

You can install the released version of benjaminileaves from
[CRAN](https://CRAN.R-project.org) with:

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
of a ficus benjamini. The main function is `benjamini_leaf()` which
results in a dataframe where i denotes the id of the bezier curve, and x
& y point coordinates:

``` r
df <- benjamini_leaf()
df
#> # A tibble: 36 × 3
#>        x     y i    
#>    <dbl> <dbl> <chr>
#>  1  10    40   stalk
#>  2  10.0  40.9 stalk
#>  3  20.0  39.4 stalk
#>  4  20    40   stalk
#>  5  20    40   1    
#>  6  22    36   1    
#>  7  29    35.2 1    
#>  8  34    35   1    
#>  9  34    35   2    
#> 10  39    34.8 2    
#> # … with 26 more rows
```

The meaning is best illustrated with a plot:

``` r
segments <- df %>% 
  group_by(i) %>% 
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
  geom_point(data = df %>% group_by(i) %>% slice(c(1, 4)), color = "blue", size = 2) +
  geom_point(data = df %>% slice(1), color = "black", size = 3) +
  ggforce::geom_bezier(aes(group = i, color = i)) +
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

The black point represents the leaf base. This and the blue points
denote the start/end points of the bezier curves, and the red dots the
positions of the control points. The leaf is cut in two halves by the
lines “4” and “4r” (which are the same and represent the midvein of the
leaf). The indices `i` which end on “r” denote the upper half of the
leaf. The exact dimensions of these coordinates are generated by random
numbers in certain ranges (see the definition of `benjamini_leaf()`).

## Illustration of the randomness

In order to show the variations of the `benjamini_leaf()` (if parameters
are not explicitly specified), let’s only pass the position of the leaf
bases and let the function randomly generate the rest of the shapes:

``` r
dfb <- expand_grid(
    x = seq(0, 200, 50),
    y = seq(25, 125, 25)
) %>%
  transpose() %>%
  map_dfr(~benjamini_leaf(gen_leaf_parameters(.x$x, .x$y)), .id = "leaf") %>%
  unite(i, i, leaf)

ggplot(dfb) +
  ggforce::geom_bezier(aes(x = x, y = y, group = i)) +
  # geom_point(data = l_points %>% bind_rows(), aes(x = x, y = y), color = "red") +
  coord_equal() +
  theme_minimal()
```

<img src="man/figures/README-plotlotsofbenjamini-1.png" width="100%" />
