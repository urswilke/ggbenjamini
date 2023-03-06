library(ggplot2)
set.seed(123)
df_leaf <- benjamini_leaf()
df_polygon <- df_leaf %>%
  tidyr::unite(b, i_part, element, remove = FALSE) %>%
  bezier_to_polygon(b, i_part, element)
df_branch <- benjamini_branch() %>%
  tidyr::unite(b, i_part, i_leaf, element, remove = FALSE)

test_that("generated bezier leaf dataframe still the same", {
  expect_snapshot(df_leaf)
})
test_that("generated bezier branch dataframe still the same", {
  expect_snapshot(df_branch)
})

test_that("bezier elements to polygons transformations work", {
  set.seed(1)
  testthat::expect_snapshot(
    df_polygon
  )
})

test_that("generated polygon ggplot object still the same", {
  skip_on_ci()
  ggraph_fun <- df_polygon %>%
    ggplot(aes(x = x, y = y, group = element, fill = element)) + geom_polygon()
  vdiffr::expect_doppelganger(
    "leaf_as_polygon_ggplot",
    ggraph_fun
  )
})
test_that("generated branch ggplot object still the same", {
  skip_on_ci()
  ggraph_fun <- df_branch %>%
    ggplot2::ggplot() +
    ggforce::geom_bezier(ggplot2::aes(x = x, y = y, group = b)) +
    ggplot2::coord_equal()

  vdiffr::expect_doppelganger(
    "branch_bezier_ggplot",
    ggraph_fun
  )
})
