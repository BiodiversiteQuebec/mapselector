test_that("subset processes data to be smaller", {
  
  fake_list <- list(
    a = data.frame(type = c(
      "végétation", "papilionidés", "acoustique", "insectes_sol", 
      "mammifères", "odonates", "zooplancton")),
    
    b = data.frame(type = c(
      "végétation", "papilionidés", "acoustique", "insectes_sol", 
      "mammifères", "odonates", "zooplancton"))
  )
  
  ss_fake <- subset_type_campaign(fake_list, "acoustique")
  
  expect_equal(purrr::map_dbl(ss_fake, nrow), c(a = 1, b = 1))
  
  ss_fake_two <- subset_type_campaign(fake_list, c("acoustique", "papilionidés"))

  expect_equal(purrr::map_dbl(ss_fake_two, nrow), c(a = 2, b = 2))
  
  })
