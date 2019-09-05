test_that("predators selected correctly", {
    test_filter <- sbd_filter(pred_species = "Fratercula arctica")
    expect_equal(nrow(test_filter), nrow(seabirddiet[seabirddiet$pred_species == "Fratercula arctica",]))
    expect_equal(ncol(test_filter), ncol(seabirddiet))
    expect_equal(unique(test_filter$pred_species), "Fratercula arctica")
    # test multiple predators
    test_filter <- sbd_filter(pred_species = c("Fratercula arctica", "Alca torda"))
    expect_equal(sort(unique(test_filter$pred_species)), c("Alca torda", "Fratercula arctica"))
})

test_that("prey selected correctly", {
    test_filter <- sbd_filter(prey_taxon = "Cottidae")
    expect_equal(nrow(test_filter), nrow(seabirddiet[seabirddiet$prey_taxon == "Cottidae",]))
    expect_equal(ncol(test_filter), ncol(seabirddiet))
    expect_equal(unique(test_filter$prey_taxon), "Cottidae")
    # test multiple prey taxa
    test_filter <- sbd_filter(prey_taxon = c("Cottidae", "Actinopterygii"))
    expect_equal(sort(unique(test_filter$prey_taxon)), c("Actinopterygii", "Cottidae"))
})

test_that("year selected correctly", {
    test_filter <- sbd_filter(year = 1983)
    expect_equal(nrow(test_filter), nrow(seabirddiet[seabirddiet$year == "1983",]))
    expect_equal(unique(test_filter$year), 1983)
    test_filter <- sbd_filter(year = "1983")
    expect_equal(unique(test_filter$year), 1983)
    # test multiple prey taxa
    test_filter <- sbd_filter(year = c("1983", 2001))
    expect_equal(sort(unique(test_filter$year)), c(1983, 2001))
    test_filter <- sbd_filter(year = 1973:1976)
    expect_equal(sort(unique(test_filter$year)), 1973:1976)
})


test_that("metrics selected correctly", {
    test_filter <- sbd_filter(pred_species = "Fratercula arctica", metrics = "freq_biomass")
    expect_equal(ncol(test_filter), ncol(seabirddiet) - 2)
    expect_false(any(is.na(test_filter$freq_biomass)))
    expect_false(any(names(test_filter) %in% c("freq_occ", "freq_num")))
})



test_that("combination selected correctly", {
    test_filter <- sbd_filter(year = 1973:1976, pred_species = "Uria aalge", 
                              prey_taxon = "Gadidae")
    expect_equal(nrow(test_filter), 
                 nrow(seabirddiet[seabirddiet$year %in% as.character(1973:1976) &
                                      seabirddiet$prey_taxon == "Gadidae" &
                                      seabirddiet$pred_species == "Uria aalge",]))
    })
