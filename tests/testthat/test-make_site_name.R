

test_data <- data.frame(
  stringsAsFactors = FALSE,
  cell_id = c(134L, 198L, 151L, 198L, 151L, 165L),
  site_code = c("135_104_H01","148_101_F01",
                "137_111_H01","148_101_H01","137_111_F01","141_108_F01"),
  cell.name = c("Mékinac (B)","Le Granit (A)",
                "Forêt Montmorency","Le Granit (A)",
                "Forêt Montmorency","Bellechasse (A)"),
  type = c("marais","forestier",
           "tourbière","tourbière","forestier","forestier")
)

test_that("name formatting works fine", {
  
  # example data from dput. NOTE it is partial
  
  with_names <- add_site_name_df(test_data) # adds display_name
  
  lv <- make_lookup_vector(with_names, "display_name", "site_code")
  
  testthat::expect_equal(lv[["135_104_H01"]], "Mékinac (B) -- marais")
  
  
  testthat::expect_equal(make_site_name("135_104_H01", cell_lookup_vec = lv),
                         "Mékinac (B) -- marais")
  
  
})




test_that("site_data gets the right, new column", {
  
  with_names <- add_site_name_df(test_data)
  
  expect_equal(with_names$display_name[1], "Mékinac (B) -- marais")
  
})


test_that("lookup vector build correctly", {
  
  v <- data.frame(x = letters[1:5], y = 6:10)
  
  expect_error(make_lookup_vector(v, "x", "z"))
  
  one_way <- make_lookup_vector(v, "x", "y")
  
  expect_equal(one_way[["7"]], "b")
  
  # handles deduplication
  vv <- data.frame(x = c(letters[1:5], "e"), y = c(6:10,10))
  
  vv_vec <- make_lookup_vector(vv, "x", "y")
  
  expect_equal(length(vv_vec), 5)
  
})
