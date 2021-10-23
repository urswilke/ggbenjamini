# this results in bezier curves quite different from those of ggforce:
# # from here: https://stackoverflow.com/a/46936532
# clean_units <- function(x){
#   attr(x,"units") <- NULL
#   class(x) <- dplyr::setdiff(class(x),"units")
#   x %>% as.numeric()
# }
#
# gen_bezier_coords <- function(df_bezier) {
#   grid::xsplineGrob(
#     # see ?grid::unit -> details -> "points" for multiplication factor 72.27
#     df_bezier$x * 72.27,
#     df_bezier$y * 72.27,
#     default.units = "points"
#   ) %>% grid::bezierPoints() %>%
#     tibble::as_tibble() %>%
#     dplyr::mutate_all(~clean_units(.x))
# }

gen_bezier_coords <- function(df_bezier, n = 100) {
  ggforce:::bezierPath(df_bezier$x, df_bezier$y, n) %>%
    tibble::as_tibble(.name_repair = "minimal") %>%
    purrr::set_names(c("x", "y"))
}

#' Transform bezier dataframe to dataframe with path coordinates
#'
#' @param df_benjamini_leaf Dataframe returned by `benjamini_leaf()`
#' @param ... grouping variables in `df_benjamini_leaf` that will be kept in the transformation.
#' @param n number of points per bezier
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
bezier_to_polygon <- function(df_benjamini_leaf, ..., n = 100) {
  group_variables <- rlang::enquos(...)
  df_benjamini_leaf %>%
    dplyr::group_by(!!!group_variables) %>%
    dplyr::summarise(gen_bezier_coords(dplyr::cur_data(), n)) %>%
    dplyr::ungroup()
}


