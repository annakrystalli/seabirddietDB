context("setup.R")

taxonomy <- readr::read_tsv(system.file("testdata","taxonomy.tsv", 
                                        package="seabirdPrey")) %>%
    dplyr::rename_all(dplyr::funs(stringr::str_replace(., "_prey", ""))) 

taxo_correct <- readr::read_csv(system.file("testdata","worrms_nomatches_verified.csv", 
                                            package="seabirdPrey"))


seabirddiet <- readr::read_csv(system.file("testdata","data.csv", 
                                           package="seabirdPrey")) %>% 
    janitor::clean_names() %>%
    dplyr::bind_cols(ID =  1:nrow(.), .)

