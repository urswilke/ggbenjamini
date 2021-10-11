#' Title
#'
#' @param x1
#' @param y1
#' @param dx21
#' @param dy21
#' @param dx32
#' @param dy32
#' @param dx43
#' @param dy43
#'
#' @return
#' @export
#'
#' @examples
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

#' Title
#'
#' @param sx1
#' @param sx2
#' @param sx3
#' @param sx4
#' @param sy1
#' @param sy2
#' @param sy3
#' @param sy4
#'
#' @return
#' @export
#'
#' @examples
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

#' Title
#'
#' @param sx1
#' @param sx2
#' @param sy1
#' @param sy2
#'
#' @return
#' @export
#'
#' @examples
gen_middle_line_slopes <- function(
  sx1 = sample(-5:-15, 1),
  sx2 = sample(-5:-15, 1),
  sy1 = runif(1, -1, 1),
  sy2 = runif(1, -1, 1)
)
  {
  tibble(
    x = c(sx1, sx2),
    y = c(sy1, sy2)
  )
}

#' Title
#'
#' @param i
#' @param points_df
#' @param slopes_df
#'
#' @return
#' @export
#'
#' @examples
#' set.seed(123)
#' points_df <- gen_benjamini_points()
#' slopes_df <- gen_benjamini_slopes()
#' get_one_bezier(1, points_df, slopes_df)
get_one_bezier <- function(i, points_df, slopes_df) {
  bind_rows(
    points_df %>% slice(i),
    slopes_df %>% slice(i) + points_df %>% slice(i),
    -slopes_df %>% slice(i + 1) + points_df %>% slice(i + 1),
    points_df %>% slice(i + 1)
  )
}

gen_middle_line_points <- function(points_df) {
  bind_rows(
    points_df %>% slice_tail(),
    points_df %>% slice_head()
  )
}


#' Title
#'
#' @param points_df
#' @param slopes_df
#'
#' @return
#' @export
#'
#' @examples
get_bezier_df <- function(points_df, slopes_df) {
  slopes_middle_df <- gen_middle_line_slopes()

  points_middle_df <- gen_middle_line_points(points_df)
  middle_line_df <- get_one_bezier(1, points_middle_df, slopes_middle_df)
  1:3 %>% map_dfr(~get_one_bezier(.x, points_df, slopes_df), .id = "i") %>%
    bind_rows(middle_line_df %>% mutate(i = "4"))
}


#' Title
#'
#' @param points_df
#'
#' @return
#' @export
#'
#' @examples
rev_points <- function(points_df) {
  points_df_rev <- points_df
  points_df_rev$y[-1] <- - points_df_rev$y[-1] + points_df_rev$y[1] + points_df_rev$y[1]
  points_df_rev
}

