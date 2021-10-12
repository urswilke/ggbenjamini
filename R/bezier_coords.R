# from here: https://stackoverflow.com/a/46936532
clean_units <- function(x){
  attr(x,"units") <- NULL
  class(x) <- dplyr::setdiff(class(x),"units")
  x %>% as.numeric()
}

gen_bezier_coords <- function(df_bezier) {
  grid::xsplineGrob(
    # see ?grid::unit -> details -> "points" for multiplication factor 72.27
    df_bezier$x * 72.27,
    df_bezier$y * 72.27,
    default.units = "points"
  ) %>% grid::bezierPoints() %>%
    tibble::as_tibble() %>%
    dplyr::mutate_all(~clean_units(.x))
}

gen_leaf_half_bezier_coords <- function(df_benjamini_leaf_half) {
  df_benjamini_leaf_half %>%
    dplyr::group_split(.data$i) %>%
    purrr::map_dfr(gen_bezier_coords)
}

#' Transform bezier dataframe to dataframe with path coordinates
#'
#' @param df_benjamini_leaf Dataframe returned by `benjamini_leaf()`
#'
#' @return Dataframe with the coordinates of the bezier curve interpolations.
#' @export
#'
#' @examples
#' df_coords <- benjamini_leaf() %>%
#'   gen_leaf_bezier_coords()
#' df_coords
#' df_coords %>%
#'   ggplot2::ggplot(ggplot2::aes(x= x, y = y, fill = half)) +
#'   ggplot2::geom_polygon()
gen_leaf_bezier_coords <- function(df_benjamini_leaf) {
  df_benjamini_leaf %>%
    dplyr::group_split(stringr::str_detect(.data$i, "r")) %>%
    purrr::map_dfr(gen_leaf_half_bezier_coords, .id = "half")
}


