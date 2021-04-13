test_that("get_subset_df returns a dataframe of all observations", {
  one_df <- get_subset_site()
  
  expect_equal(dim(one_df), c(203L, 28L))
  
  
})
