#' Generate a branch of benjamini leaves
#'
#' @param df_branch dataframe containing the 4 x & y bezier coordinates of a branch
#' @param leaf_mean_dist_approx approximate distance of two leaves
#' @param leaf_angle angle between the leaf stalks and the branch
#' @param first_dir direction of the first leaf in the branch (0 for right; 1 for left)
#' @param leave_size_dist Manipulate the sizes of the leaves with a spark function
#'   This function returns a function which itself returns a numerical vector of
#'   length of the number of leaves on the branch. The function will be rescaled
#'   (divided by it's maximum value).
#' @param leaf_angle_dist Manipulate the leaf angles with a spark function
#'   This function returns a function which itself returns a numerical vector of
#'   length of the number of leaves on the branch.
#' @param last_angle_straight Logical if the angle of the last leaf on the
#'   branch is very sharp (defaults to TRUE).
#' @param leaf_size_multiplicator Multiply leaf size distribution with a factor.
#'
#' @return A dataframe containing the data for leaves on a branch (see example).
#' @export
#'
#' @examples
#' benjamini_branch() %>%
#'   tidyr::unite(b, i_part, i_leaf, element, remove = FALSE) %>%
#'   ggplot2::ggplot() +
#'   ggforce::geom_bezier(ggplot2::aes(x = x, y = y, group = b)) +
#'   ggplot2::coord_equal()
benjamini_branch <- function(
  df_branch = tibble::tibble(
    x = c(70, 84, 126, 168),
    y = c(280, 245, 217, 217)
  ),
  leaf_mean_dist_approx = 10, leaf_angle = 45,
  first_dir = sample(0:1, 1),
  # Idea from flametree::flametree_grow()
  leave_size_dist = spark_weibull(shape = 1.5, scale_factor = 0.8),
  leaf_angle_dist = spark_norm(mean = 0, sd = 3),
  last_angle_straight = TRUE,
  leaf_size_multiplicator = 1
) {
  df_coords <- gen_bezier_lin_interp(df_branch)

  n_points <- nrow(df_coords)
  dx <- df_coords$x[-n_points] - df_coords$x[-1]
  dy <- df_coords$y[-n_points] - df_coords$y[-1]
  angle <- atan2(dy, dx) / pi * 2 * 90

  leaf_indices <- get_leaf_indices(dx, dy, leaf_mean_dist_approx, n_points)

  n_leaves <- length(leaf_indices)


  x_leaves <- df_coords$x[leaf_indices + 1]
  y_leaves <- df_coords$y[leaf_indices + 1]
  l_leaf_bases <- tibble::tibble(x = x_leaves, y = y_leaves) %>% purrr::transpose()


  stalk_angle_pos <- angle - leaf_angle
  stalk_angle_neg <- angle + leaf_angle
  stalk_angle_pos <- stalk_angle_pos[leaf_indices]
  stalk_angle_neg <- stalk_angle_neg[leaf_indices]

  pos_positions <- (1:n_leaves + first_dir) %% 2 == 1
  neg_positions <- (1:n_leaves + first_dir) %% 2 == 0

  leaf_angles <- vector("numeric", n_leaves)
  leaf_angles[pos_positions] <- stalk_angle_pos[pos_positions]
  leaf_angles[neg_positions] <- stalk_angle_neg[neg_positions]

  if (last_angle_straight) {
    leaf_angles[n_leaves] <- (2 * angle[length(angle)] + leaf_angles[n_leaves]) / 3
  }

  leaf_angles <- leaf_angles + leaf_angle_dist(n_leaves)

  dist_multiplicator <- leave_size_dist(n_leaves)
  dist_multiplicator <- dist_multiplicator * leaf_size_multiplicator


  leaves <- purrr::pmap_dfr(
    list(
      l_leaf_bases,
      leaf_angles,
      dist_multiplicator
    ),
    function(x, y, z) benjamini_leaf(gen_leaf_parameters(x0 = x$x, y0 = x$y) %>% resize_leaf_params(z), omega = y + 180),
    .id = "i_leaf"
  ) %>%
    dplyr::mutate(i_leaf = as.numeric(.data$i_leaf)) %>%
    dplyr::mutate(type = "leaf_bezier")

  dplyr::bind_rows(
    df_branch %>%
      dplyr::mutate(
        i_part = 1,
        i_leaf = 0,
        type = "branch",
        element = "branch"
      ) %>%
      add_bezier_point_type_column(),
    leaves
  ) %>%
    dplyr::relocate(c("i_leaf", "element", "i_part"))

}

get_leaf_indices <- function(dx, dy, leaf_mean_dist_approx, n_points) {
  segment_lengths <- sqrt((dx)^2 + (dy)^2)

  branch_length <- sum(segment_lengths)
  possible_leaf_dists <- branch_length /
    leaf_mean_dist_approx *
    exp(-(seq(0, 3, length.out = 100))) %>%
    cumsum()
  leaf_dists <- possible_leaf_dists[possible_leaf_dists <= branch_length]

  leaf_indices <- leaf_dists %>%
    purrr::map_int(~which.max(.x < cumsum(segment_lengths)))
  if (max(leaf_indices < n_points - 1)) {
    leaf_indices[length(leaf_indices) + 1] <- n_points - 1
  }

  leaf_indices
}

#' Manipulate the sizes of the leaves with a Weibull distribution
#'
#' This function returns a function which itself returns a numerical vector of
#' length `n_leaves`, the number of leaves on the branch. These values serve
#' as relative multiplication factors of the sizes of the leaves of the branch.
#' (The maximum value of this distribution is then normalized to 1.)
#'
#' @param shape,scale_factor Parameters passed to `stats::dweibull()`.
#'
#' @return dweibull() function depending on n_leaves as one of the arguments
#' @export
#'
#' @examples
#' #Mark the two consecutive pairs of parentheses:
#' spark_weibull()(n_leaves = 10)
spark_weibull <- function(shape = 1.2, scale_factor = 0.5) {
  function(n_leaves) {
    distribution <- stats::dweibull(1:n_leaves, shape, scale = n_leaves * scale_factor)
    distribution / max(distribution)
  }
}

#' Manipulate the angles of the leaves with a normal distribution
#'
#' This function returns a function which itself returns a numerical vector of
#' length of the number of leaves on the branch.
#'
#' @param mean,sd Parameters passed to `stats::dnorm()`.
#'
#' @return dnorm() function with n_leaves as one of the arguments
#' @export
#'
#' @examples
#' spark_norm()
spark_norm <- function(mean = 0, sd = 3) {
  function(n_leaves) {
    stats::rnorm(n_leaves, mean = mean, sd = sd)
  }
}
