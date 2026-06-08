#' Transform bezier dataframe to dataframe with path coordinates
#'
#' @param df_benjamini_leaf Dataframe returned by `benjamini_leaf()`
#' @param ... grouping variables in `df_benjamini_leaf` that will be kept in the transformation.
#'
#' @return Dataframe with the coordinates of the bezier curve interpolations.
#' @export
#'
#' @examples
#' df_coords <- benjamini_leaf() %>%
#'   tidyr::unite(b, i_part, element, remove = FALSE) %>%
#'   bezier_to_polygon(b, i_part, element)
#' df_coords
#' df_coords %>%
#'   ggplot2::ggplot(ggplot2::aes(x = x, y = y, group = element, fill = element)) +
#'   ggplot2::geom_polygon()
bezier_to_polygon <- function(df_benjamini_leaf, ...) {
  group_variables <- rlang::enquos(...)
  df_benjamini_leaf %>%
    dplyr::group_by(!!!group_variables) %>%
    dplyr::reframe(calc_bezier_points(dplyr::pick(dplyr::everything())))
}

calc_bezier_points <- function(df_branch) {
  ttt <- seq(0, 1, length.out=100)
  if (nrow(df_branch) == 4) {
    df_branch$id_pathtree <- 1
  }
  res <- df_branch |> split(df_branch$id_pathtree) |> purrr::map_dfr(\(x) as.matrix(x[c("x", "y")]) |> bezier::bezier(t = ttt, p = _) |> as.data.frame())
  names(res) <- c("x", "y")
  res |> tibble::as_tibble()
}

