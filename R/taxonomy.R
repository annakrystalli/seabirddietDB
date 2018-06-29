get_tx_base_name <- function(x){tail(na.omit(unlist(x)), 1)}
get_tx_base_rank <- function(x, ranks = names(taxonomy)){
    ranks[which(x == tail(na.omit(unlist(x)), 1))]
}

get_valid_taxon <- function(base_name){
    out <- data.frame(aphiaID = NA, valid_name = NA, valid_aphiaID = NA)
    
    qres <- try(worrms::wm_records_names(base_name)[[1]], silent = T)
    if(inherits(qres, "try-error")) {
        aphiaID <- try(worrms::wm_name2id(base_name), silent = T)
        if(inherits(aphiaID, "try-error")) {
            warning("No valid aphiaID returned for base_name: ", base_name)
            return(out)}
        if(aphiaID < 0) {
            warning("No valid aphiaID returned for base_name: ", base_name)
            return(out)}
        qres <- worrms::wm_record(aphiaID)
        if(inherits(qres, "try-error")) {
            return(out)
        }}
    
    valid_aphiaID <- qres$valid_AphiaID[1]
    aphiaID <- qres$AphiaID[1]
    out$aphiaID <- ifelse(aphiaID < 0, NA, aphiaID)
    out$valid_aphiaID <- ifelse(valid_aphiaID < 0, NA, valid_aphiaID)
    out$valid_name <- qres$valid_name[1]
    
    return(out)
}


get_row_base <- function(taxonomy){
    taxonomy %>%
        dplyr::rowwise() %>% 
        dplyr::do({
            result = dplyr::as_data_frame(.)
            result$base_name = get_tx_base_name(.) %>% unlist
            result$base_rank = get_tx_base_rank(., ranks = names(.)) %>% unlist
            result}) 
}

worrms_validate <- function(taxonomy){
    taxonomy %>% 
        do(get_valid_taxon(.$base_name)) %>% 
        bind_cols(taxonomy, .)
}

recode_spp_manual <- function(df, path = here::here("data-raw", 
                                                    "worrms_nomatches_verified.csv"), 
                              df_type = c("taxonomy", "data")){
    
    df_type <- match.arg(df_type)
    taxo_correct <- readr::read_csv(path)
    taxo_recode <- taxo_correct %>% 
        dplyr::pull(verified_base_name) %>% 
        setNames(taxo_correct$base_name)
    switch(df_type,
           "taxonomy" = {
               df %>% 
                   dplyr::mutate(species = plyr::revalue(species, taxo_recode))
           },
           "data" = {
               df %>% 
                   dplyr::mutate(prey_species = plyr::revalue(prey_species, taxo_recode))
           }) 
}
