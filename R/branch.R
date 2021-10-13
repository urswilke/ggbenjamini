#' Generate a branch of benjamini leaves
#'
#' @param df_branch dataframe containing the x & y coordinates of a branch
#' @param leaf_dist_approx approximate distance of two leaves
#' @param leaf_angle angle between the leaf stalks and the branch
#' @param first_dir direction of the first leaf in the branch (0 for right; 1 for left)
#' @param stalk_len length of a stalk
#'
#' @return A dataframe conaining the data for leaves on a branch (see example).
#' @export
#'
#' @examples
#' benjamini_branch() %>%
#'   ggplot2::ggplot(ggplot2::aes(x = x1, y = y1, xend = x2, yend = y2)) +
#'   ggplot2::geom_segment() +
#'   ggforce::geom_bezier(ggplot2::aes(x = x, y = y, group = i)) +
#'   ggplot2::coord_equal()
benjamini_branch <- function(
  df_bezier = tibble::tibble(
    x = c(70, 84, 126, 168),
    y = c(280, 245, 217, 217)
  ),
  leaf_dist_approx = 20, leaf_angle = 45,
  first_dir = sample(0:1, 1),
  stalk_len = 15
) {
  df_coords <- gen_bezier_coords(df_bezier)

  n_points <- nrow(df_coords)
  dx <- df_coords$x[-n_points] - df_coords$x[-1]
  dy <- df_coords$y[-n_points] - df_coords$y[-1]
  angle <- atan2(dy, dx) / pi * 2 * 90

  branch_length <- sqrt((dx)^2 + (dy)^2)

  n_leaves <- round(sum(branch_length) / leaf_dist_approx)

  leaf_dist <- sum(branch_length) / (n_leaves + 1)

  leaf_indices <- (1:n_leaves * leaf_dist) %>%
    purrr::map_int(~which.max(.x < cumsum(branch_length)))
  leaf_indices[length(leaf_indices)] <- n_points - 1

  x_leaves <- df_coords$x[leaf_indices + 1]
  y_leaves <- df_coords$y[leaf_indices + 1]


  stalk_angle_pos <- angle - leaf_angle
  stalk_angle_neg <- angle + leaf_angle
  stalk_angle_pos <- stalk_angle_pos[leaf_indices]
  stalk_angle_neg <- stalk_angle_neg[leaf_indices]

  dx_stalk_pos <- cos(stalk_angle_pos/90*pi/2) * stalk_len
  dy_stalk_pos <- sin(stalk_angle_pos/90*pi/2) * stalk_len
  dx_stalk_neg <- cos(stalk_angle_neg/90*pi/2) * stalk_len
  dy_stalk_neg <- sin(stalk_angle_neg/90*pi/2) * stalk_len

  xends <- vector("numeric", n_leaves)
  pos_positions <- (1:n_leaves + first_dir) %% 2 == 1
  neg_positions <- (1:n_leaves + first_dir) %% 2 == 0
  xends[pos_positions] <- x_leaves[pos_positions] - dx_stalk_pos[pos_positions]
  xends[neg_positions] <- x_leaves[neg_positions] - dx_stalk_neg[neg_positions]
  yends <- vector("numeric", n_leaves)
  yends[pos_positions] <- y_leaves[pos_positions] - dy_stalk_pos[pos_positions]
  yends[neg_positions] <- y_leaves[neg_positions] - dy_stalk_neg[neg_positions]

  leaf_stalks <- tibble::tibble(
    x1 = x_leaves,
    y1 = y_leaves,
    x2 = xends,
    y2 = yends,
    type = "leaf_stalk"
  )

  l_leaf_bases <- leaf_stalks %>% dplyr::select(x1 = x2, y1 = y2) %>% purrr::transpose()
  leaf_angles <- vector("numeric", n_leaves)
  leaf_angles[pos_positions] <- stalk_angle_pos[pos_positions]
  leaf_angles[neg_positions] <- stalk_angle_neg[neg_positions]

  dist_multiplicator <- dpois(1:n_leaves, 4)
  dist_multiplicator <- dist_multiplicator/max(dist_multiplicator)


  leaves <- purrr::pmap_dfr(
    list(
      l_leaf_bases,
      leaf_angles,
      dist_multiplicator
    ),
    function(x, y, z) benjamini_leaf(gen_leaf_parameters(x1 = x$x, y1 = x$y) %>% resize_leaf_params(z), omega = y + 180),
    .id = "leaf"
  ) %>%
    dplyr::mutate(type = "leaf_bezier") %>%
    tidyr::unite("i", .data$i, .data$leaf)

  dplyr::bind_rows(
    df_bezier,
    leaf_stalks,
    leaves
  )

}
