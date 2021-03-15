

# could improve this eh
downloaded_sites <- rcoleo::download_sites_sf(token = Sys.getenv("RCOLEO_TOKEN"))

test_that("observation_display works as expected",{
  testServer(mod_observation_display_server, 
             args = list(
               site = downloaded_sites,
               region = reactive("132_116_F01")
             ),
             {
               
               testthat::expect_equal(names(to_show()), c("date", "espece"))
               
               testthat::expect_s3_class(to_show(), "data.frame")
             })
})