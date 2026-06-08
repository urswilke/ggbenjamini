# Generate bezier coordinates of a leaf

Except the start point coordinates of the leaf origin `x0` & `y0`
(arbitrarily set to 10 and 40) all coordinates are relative to this
origin. Most of the parameters are random generated, except for some of
them (e.g., to close polygons, or to keep the stalk and the mid vein on
the same line).

## Usage

``` r
gen_leaf_parameters(
  x0 = 10,
  y0 = 40,
  dx10 = sample(8:12, 1),
  dy10 = 0,
  dx21 = sample(12:20, 1),
  dy21 = sample(-4:-10, 1),
  dx32 = sample(10:18, 1),
  dy32 = stats::runif(1, 0.92 * (-dy21 - 1), 0.95 * (-dy21 - 1)),
  dx43 = sample(4:6, 1),
  dy43 = y0 + dy10 + dy21 + dy32,
  sx0 = stats::runif(1, 0, 0.1),
  sx1 = sample(1:3, 1),
  sx2 = sample(4:6, 1),
  sx3 = sample(2:4, 1),
  sx4 = stats::runif(1, 0, 0.2),
  sy0 = stats::runif(1, 0.5, 1),
  sy1 = sample(-4:-6, 1),
  sy2 = stats::runif(1, -0.5, 0.5),
  sy3 = stats::runif(1, 0.5, 1.5),
  sy4 = stats::runif(1, 0.2, 0.7),
  smx1 = sample(-5:-15, 1),
  smx2 = sample(-5:-15, 1),
  smy1 = stats::runif(1, -1, 1),
  smy2 = stats::runif(1, -1, 1)
)
```

## Arguments

- x0, y0:

  coordinates of the leaf origin

- dx10, dy10, dx21, dy21, dx32, dy32, dx43, dy43:

  coordinates of the other bezier start & end points

- sx0, sx1, sx2, sx3, sx4:

  x coordinates of the control points

- sy0, sy1, sy2, sy3, sy4:

  y coordinates of the control points

- smx1, smx2, smy1, smy2:

  x & y coordinates of the mid vein control points

## Value

named list of all parameters

## Examples

``` r
gen_leaf_parameters()
#> $x0
#> [1] 10
#> 
#> $y0
#> [1] 40
#> 
#> $dx10
#> [1] 9
#> 
#> $dy10
#> [1] 0
#> 
#> $dx21
#> [1] 19
#> 
#> $dy21
#> [1] -10
#> 
#> $dx32
#> [1] 16
#> 
#> $dy32
#> [1] 8.491727
#> 
#> $dx43
#> [1] 6
#> 
#> $dy43
#> [1] 38.49173
#> 
#> $sx0
#> [1] 0.0101951
#> 
#> $sx1
#> [1] 3
#> 
#> $sx2
#> [1] 5
#> 
#> $sx3
#> [1] 2
#> 
#> $sx4
#> [1] 0.105987
#> 
#> $sy0
#> [1] 0.6292132
#> 
#> $sy1
#> [1] -5
#> 
#> $sy2
#> [1] 0.4684625
#> 
#> $sy3
#> [1] 1.161078
#> 
#> $sy4
#> [1] 0.5981253
#> 
#> $smx1
#> [1] -7
#> 
#> $smx2
#> [1] -14
#> 
#> $smy1
#> [1] 0.04685683
#> 
#> $smy2
#> [1] -0.06024217
#> 
```
