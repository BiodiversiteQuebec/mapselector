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
  
  ss_list <- subset_type_campaign(fake_list, "zooplancton")
  
  expect_equal(purrr::map_dbl(ss_fake, nrow), c(a = 1, b = 1))
  
  ss_fake_two <- subset_type_campaign(fake_list, c("acoustique", "papilionidés"))

  expect_equal(purrr::map_dbl(ss_fake_two, nrow), c(a = 2, b = 2))
  
  # check error
  expect_error(subset_type_campaign(fake_list, "foobar"))
  
  })


test_that("works as expected for zoops",{
  
  rcoleo_sites_sf <- rcoleo::download_sites_sf(site_code = "132_116_L01", token = rcoleo:::bearer())
  
  df <- subset_type_campaign(rcoleo_sites_sf$campaigns, "zooplancton")
  
  expect_equal(nrow(df[[1]]), 1)
  
  # seems OK... 
  
  rcoleo_sites_sf2 <- rcoleo::download_sites_sf(site_code = "136_116_H01", token = rcoleo:::bearer())
  
  # this site has odonates and butterflies, but no zoops (at least, at the time of this writing)
  
  result <- subset_site_df(rcoleo_sites_sf2, c("odonates", "zooplancton"))$campaigns  
  
  expect_equal(result, list())
  
  expect_error(subset_type_campaign(rcoleo_sites_sf2$campaigns, "odonate")) # check error message too!!!
  
  
})
