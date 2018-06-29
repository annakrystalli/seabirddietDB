context("test-taxonomy.R")

# recode manual corrections ----
t_taxonomy <- taxonomy %>%
    recode_spp_manual()

test_that("recoding taxonomy works", {
    
    testthat::expect_true(all(!taxo_correct$base_name %in% t_taxonomy$species))
    testthat::expect_true(all(taxo_correct$verified_base_name %in% t_taxonomy$species))
})

test_that("recoding data works", {
    t_seabirddiet <- seabirddiet %>%
        recode_spp_manual(df_type = "data")
    
    testthat::expect_true(all(!taxo_correct$base_name %in% t_seabirddiet$prey_species))
    testthat::expect_true(all(taxo_correct$verified_base_name %in% t_taxonomy$species))
})

# extract base info from each row ----
t_taxonomy <- t_taxonomy %>%
    get_row_base()

test_that("rowwise base name and rank extracted correctly",{
    expect_equal(t_taxonomy$base_name %>% head(10),
                 c("Arnoglossus laterna", "Hippoglossoides platessoides", "Pleuronectes platessa", 
                   "Microstomus kitt", "Limanda limanda", "Limanda", "Pleuronectidae", 
                   "Phrynorhombus norvegicus", "Pleuronectiformes", "Ammodytes marinus"
                 ))
    expect_equal(t_taxonomy$base_rank %>% head(10),
                 c("species", "species", "species", "species", "species", "genus", 
                   "family", "species", "order", "species"))
    expect_true(!any(is.na(t_taxonomy$base_rank)))
    expect_equivalent(unique(t_taxonomy$base_rank),
                      c("species", "genus", "family", "order", "class", "phylum"))
    
})


