context("test-eml.R")

test_that("date-range-extraction-works", {
   x <- c(1961L, 1961L, 1961L, 1961L, 1975L, 1975L, 1983L, 1983L, 1983L, 
      1973L, NA, NA, 1984L, 1984L, 1984L, 1984L, 1984L, 1984L, 1963L, 
      1963L, 1989L, 1989L)
   yr_to_isorange(x, type = "start")  
    
  expect_equal(yr_to_isorange(x, type = "start"), 
               structure(-3287, .Names = "start", class = "Date"))
  expect_equal(yr_to_isorange(x, type = "end"), 
               structure(7304, .Names = "end", class = "Date"))
  expect_equal(yr_to_isorange(x), 
               structure(c(-3287, 7304), 
                         .Names = c("start", "end"), class = "Date"))
  })
