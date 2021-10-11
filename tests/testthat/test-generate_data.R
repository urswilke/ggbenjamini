set.seed(123)
test_that("generated bezier dataframe still the same", {
  expect_snapshot(get_bezier_df())
})
