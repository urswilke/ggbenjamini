gen_benjamini_points <- function(
  x1 = 10,
  y1 = 40,
  dx21 = sample(12:20, 1),
  dy21 = sample(-4:-10, 1),
  dx32 = sample(10:18, 1),
  dy32 = runif(1, 0.88 * (-dy21 - 1), 0.92 * (-dy21 - 1)),
  dx43 = sample(4:6, 1),
  dy43 = y1 + dy21 + dy32
) {
  x2 <- x1 + dx21
  y2 <- y1 + dy21
  x3 <- x2 + dx32
  y3 <- y2 + dy32
  x4 <- x3 + dx43
  y4 <- y1

  tibble(
    x = c(x1, x2, x3, x4),
    y = c(y1, y2, y3, y4)
  )
}

gen_benjamini_slopes <- function(
  sx1 = sample(1:3, 1),
  sx2 = sample(4:6, 1),
  sx3 = sample(2:4, 1),
  sx4 = runif(1, 0, 0.2),
  sy1 = sample(-4:-6, 1),
  sy2 = runif(1, -0.5, 0.5),
  sy3 = runif(1, 0.5, 1.5),
  sy4 = runif(1, 0.5, 1.5)
) {
  tibble(
    x = c(sx1, sx2, sx3, sx4),
    y = c(sy1, sy2, sy3, sy4)
  )
}
