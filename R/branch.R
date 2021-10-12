#' Title
#'
#' @param df_branch dataframe containing the x & y coordinates of a branch
#' @param leaf_dist_approx approximate distance of two leaves
#' @param leaf_angle angle between the leaf stalks and the branch
#' @param first_dir direction of the first leaf in the branch (0 for right; 1 for left)
#' @param stalk_len length of a stalk
#'
#' @return
#' @export
#'
#' @examples
#' benjamini_branch() %>%
#'   ggplot2::ggplot(ggplot2::aes(x = x1, y = y1, xend = x2, yend = y2)) +
#'   ggplot2::geom_segment() +
#'   ggforce::geom_bezier(aes(x = x, y = y, group = i)) +
#'   ggplot2::coord_equal()
benjamini_branch <- function(
  df_branch = tibble(x1 = 0, x2 = 100, y1 = 40, y2 = 40),
  leaf_dist_approx = 20, leaf_angle = 45,
  first_dir = sample(0:1, 1),
  stalk_len = 15
) {
  x1 <- df_branch$x1
  x2 <- df_branch$x2
  y1 <- df_branch$y1
  y2 <- df_branch$y2

  dx <- x2 - x1
  dy <- y2 - y1
  angle <- atan2(dy, dx) / pi * 2 * 90

  branch_length <- sqrt((dx)^2 + (dy)^2)

  n_leaves <- round(branch_length / leaf_dist_approx) - 1

  leaf_dist <- branch_length / (n_leaves + 1)

  x_leaves <- seq(x1, x2, length.out = n_leaves + 1)[-1]
  y_leaves <- seq(y1, y2, length.out = n_leaves + 1)[-1]


  stalk_angle_pos <- angle + leaf_angle
  stalk_angle_neg <- angle - leaf_angle

  dx_stalk_pos <- cos(stalk_angle_pos/90*pi/2) * stalk_len
  dy_stalk_pos <- sin(stalk_angle_pos/90*pi/2) * stalk_len
  dx_stalk_neg <- cos(stalk_angle_neg/90*pi/2) * stalk_len
  dy_stalk_neg <- sin(stalk_angle_neg/90*pi/2) * stalk_len

  xends <- vector("numeric", n_leaves)
  pos_positions <- (1:n_leaves + first_dir) %% 2 == 0
  neg_positions <- (1:n_leaves + first_dir) %% 2 == 1
  xends[pos_positions] <- x_leaves[pos_positions] + dx_stalk_pos
  xends[neg_positions] <- x_leaves[neg_positions] + dx_stalk_neg
  yends <- vector("numeric", n_leaves)
  yends[pos_positions] <- y_leaves[pos_positions] + dy_stalk_pos
  yends[neg_positions] <- y_leaves[neg_positions] + dy_stalk_neg

  leaf_stalks <- tibble(
    x1 = x_leaves,
    y1 = y_leaves,
    x2 = xends,
    y2 = yends,
    type = "leaf_stalk"
  )

  l_leaf_bases <- leaf_stalks %>% select(x1 = x2, y1 = y2) %>% transpose()
  leaf_angles <- vector("numeric", n_leaves)
  leaf_angles[pos_positions] <- stalk_angle_pos
  leaf_angles[neg_positions] <- stalk_angle_neg

  leaves <- map2_dfr(
    l_leaf_bases,
    leaf_angles,
    ~benjamini_leaf(gen_benjamini_points(.x$x, .x$y), omega = .y),
    .id = "leaf"
  ) %>%
    mutate(type = "leaf_bezier") %>%
    unite(i, i, leaf)

  bind_rows(
    df_branch,
    leaf_stalks,
    leaves
  )

}
