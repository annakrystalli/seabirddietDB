library(dplyr)
get_taxo_base <- function(x){tail(na.omit(unlist(x)), 1)}

get_valid_taxon <- function(base){
    qres <- try(worrms::wm_records_names(base), silent = T)
    if(class(qres) == "try-error") {
        warning("No valid_name returned for base: ", base)
        return(data.frame(valid_name = NA, 
                          aphiaID = NA))
        }else{
        return(data.frame(valid_name = qres[[1]]$valid_name[1], 
                              aphiaID = qres[[1]]$valid_AphiaID[1]))
        }
}

worrms_taxonomy <- function(taxonomy){
    taxonomy %>% do(get_valid_taxon(.$base)) %>% bind_cols(taxonomy, .)
}


taxonomy <- readr::read_tsv(here::here("data", "metadata", "taxonomy.tsv")) %>%
    rowwise %>% 
    do({
        result = as_data_frame(.)
        result$base = get_taxo_base(.) %>% unlist
        result}) %>% 
    worrms_taxonomy()


function()
    
    taxonomy %>%
        filter(is.na(valid_name)) %>% pull(base)
        
        
assertr::assert()