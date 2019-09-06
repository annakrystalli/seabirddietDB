csv <- purrr::map_df(readr::read_csv(system.file("csv", "seabirddiet.csv", 
                                                 package = "seabirddietDB"), 
                                     col_types = readr::cols(),
                                     guess_max = 1500), as.character)

test_that("seabird package data and latest csv match", {
  expect_equivalent(csv, purrr::map_df(seabirddiet, as.character))
})

test_that("seabirddiet_ correct", {
    expect_equivalent(
        purrr::map_df(dplyr::select(seabirddiet, -.data$longitude, -.data$latitude), as.character),
        purrr::map_df(sf::st_drop_geometry(seabirddiet_), as.character))
    
    expect_equal(ncol(seabirddiet) - 1, ncol(seabirddiet_))
    expect_equal(class(seabirddiet_), c("sf", "tbl_df", "tbl", "data.frame"))
})
