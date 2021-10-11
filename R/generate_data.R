gen_benjamini_points <- function(
  x1 = 10,
  y1 = 40,
  dx21 = 20,
  dy21 = -10,
  dx32 = 10,
  dy32 = 9,
  dx43 = 5,
  dy43 = y1
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
  sx1 = 4, sx2 = 5, sx3 = 3, sx4 = 0,
  sy1 = -10, sy2 = 2, sy3 = 1, sy4 = 1
) {
  tibble(
    x = c(sx1, sx2, sx3, sx4),
    y = c(sy1, sy2, sy3, sy4)
  )
}
