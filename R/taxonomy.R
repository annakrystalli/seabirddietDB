get_taxo_base <- function(x){tail(na.omit(unlist(x)), 1)}

get_valid_taxon <- function(base){
    qres <- try(worrms::wm_records_names(base), silent = T)
    if(class(qres) == "try-error") {
        aphiaID <- try(worrms::wm_name2id(base), silent = T)
        if(class(aphiaID) == "try-error") {
            warning("No valid aphiaID returned for base: ", base)
            return(data.frame(valid_name = NA, aphiaID = NA))}
        if(aphiaID < 0) {
            warning("No valid aphiaID returned for base: ", base)
            return(data.frame(valid_name = NA, aphiaID = NA))}
        qres <- worrms::wm_record(aphiaID)
        if(class(qres) == "try-error") {
            return(data.frame(valid_name = NA, aphiaID = NA))
        }
        return(data.frame(valid_name = qres$valid_name, 
                          aphiaID = qres$valid_AphiaID))
    }else{
        aphiaID <- qres[[1]]$valid_AphiaID[1]
        return(data.frame(valid_name = qres[[1]]$valid_name[1], 
                          aphiaID = ifelse(aphiaID < 0, NA, aphiaID)))
    }
}

worrms_taxonomy <- function(taxonomy){
    taxonomy %>% 
        do(get_valid_taxon(.$base)) %>% 
        bind_cols(taxonomy, .)
}

correct_manual <- function(taxonomy){
    taxo_correct <- readr::read_csv(here::here("data-raw",
                                               "worrms_nomatches_verified.csv"))
    taxo_recode <- taxo_correct %>% 
        pull(verified_base) %>% 
        setNames(taxo_correct$base)
    
    taxonomy %>% 
        mutate(species_prey = plyr::revalue(species_prey, taxo_recode))
}