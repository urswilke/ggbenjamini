set.seed(123)
test_that("generated bezier leaf dataframe still the same", {
  expect_snapshot(benjamini_leaf())
})
test_that("generated bezier branch dataframe still the same", {
  expect_snapshot(benjamini_branch())
})
