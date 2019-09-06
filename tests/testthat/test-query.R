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

test_that("sbd_predators prints correctly", {

    expect_equal(sbd_predators(), sort(unique(seabirddiet$pred_species)))
    expect_equal(sbd_predators(verbose = T)$pred_species, 
                 sort(unique(seabirddiet$pred_species)))
    expect_s3_class(sbd_predators(verbose = T), c("tbl_df", "tbl", "data.frame"))
    expect_equal(names(sbd_predators(verbose = T)), 
                 c("pred_species", "pred_rank", "pred_aphia_id", "pred_valid_name", 
                   "pred_valid_aphia_id"))
})

test_that("sbd_prey prints correctly", {
    
    expect_equal(sbd_prey(), sort(unique(seabirddiet$prey_taxon)))
    expect_equal(sbd_prey(verbose = T)$prey_taxon, 
                 sort(unique(seabirddiet$prey_taxon)))
    expect_s3_class(sbd_prey(verbose = T), c("tbl_df", "tbl", "data.frame"))
    expect_equal(names(sbd_prey(verbose = T)), 
                 c("prey_taxon", "prey_rank", "prey_aphia_id", "prey_valid_name", 
                   "prey_valid_aphia_id"))
})