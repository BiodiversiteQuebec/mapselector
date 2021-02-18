library(testthat)
# library(mapselector)

test_dir(
  "./tests/testthat",
  env = shiny::loadSupport(),
  reporter = c("progress", "fail")
)

# test_check("mapselector")
