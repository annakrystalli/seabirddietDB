#' Get row taxonomic base
#'
#' Get the taxonomic base of each row in the original `taxonomy.tsv`.
#'
#' @param taxonomy taxonomy data.frame
#'
#' @return the data.frame supplied with a column containing the taxonomic base
#' of each row appended.
#' @export
get_row_base <- function(taxonomy){
    taxonomy %>%
        dplyr::rowwise() %>% 
        dplyr::do({
            result = dplyr::as_data_frame(.)
            result$base_name = get_tx_base_name(.) %>% unlist
            result$base_rank = get_tx_base_rank(., ranks = names(.)) %>% unlist
            result}) %>%
        bind_rows() %>% 
        dplyr::select(dplyr::starts_with("base"))
}

#' Validate species in taxonomy against WoRMS database
#'
#' @param names vector of names to check
#'
#' @return the data.frame with the `aphia_id`, the valid aphia id and valid 
#' name returned for the queried for the original species name
#' @export
#'
worrms_validate <- function(names){
    names %>%
        unique() %>%
        magrittr::extract(. != "other") %>%
            purrr::map_df(~get_valid_taxon(.x))
}

#' Recode species with manual corrections table
#'
#' @param df data.frame in which to recode species
#' @param path the path to the manual match csv
#' @param df_type whether the data.frame supplied is the `taxonomy` df or the 
#' seabirddiet `data` df.
#'
#' @return the data.frame supplied with the species names recoded
#' @export
recode_spp_manual <- function(df, path = here::here("data-raw", "manual_corrections",
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


get_tx_base_name <- function(x){tail(na.omit(unlist(x)), 1)}
get_tx_base_rank <- function(x, ranks = names(taxonomy)){
    ranks[which(x == tail(na.omit(unlist(x)), 1))]
}
get_valid_taxon <- function(base_name){
    out <- tibble::tibble(base_name = base_name, rank = NA, aphia_id = NA, 
                      valid_name = NA, valid_aphia_id = NA)
    
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
    out$aphia_id <- ifelse(aphiaID < 0, NA, aphiaID)
    out$valid_aphia_id <- ifelse(valid_aphiaID < 0, NA, valid_aphiaID)
    out$valid_name <- qres$valid_name[1]
    out$rank <- qres$rank[1]
    
    return(out)
}


#' Title
#'
#' @param base_name 
#' @param ranks 
#'
#' @return
#' @export
classify_validname <- function(valid_name, ranks = c("phylum", "class", "order", 
                                                   "family", "genus", "species")){
    
    out <- worrms::wm_classification_(name = valid_name) %>% 
        # convert rank to lower case
        dplyr::mutate(rank = tolower(.data$rank)) %>%
        # filter for taxonomic info matching raw taxonomy column names
        dplyr::filter(.data$rank %in% as.vector(ranks))  %>%  
        # remove non base taxonomic AphiaID
        dplyr::select(-.data$AphiaID) %>%
        # covenrt to wide to match taxonomy
        tidyr::spread(., key = .data$rank, value = scientificname) 
    
    out[ranks] %>% dplyr::arrange(!!!as.name(ranks))
    
}

#' Title
#'
#' @param taxonomy 
#'
#' @return
#' @export
#'
#' @examples
validate_taxonomy <- function(taxonomy) {
    taxonomy %>%
    assertr::assert(assertr::is_uniq, base_name) %>% 
        assertr::assert(assertr::not_na, rank, valid_name, valid_aphia_id, aphia_id) %>% 
        assertr::verify(assertr::has_all_names("base_name", "rank", "aphia_id", 
                                               "valid_name", "valid_aphia_id")) %>%
        assertr::verify(valid_aphia_id > 0)
}

#' Bind taxonomy columns to dataset
#'
#' @param data dataset
#' @param role whether the taxonomy relates to
#'
#' @return
#' @export
bind_taxonomy <- function(data, taxonomy, role = c("prey", "pred")) {
    # set join column names
    role <- match.arg(role)
    data_base_name <- switch (role,
                              pred = "species",
                              prey = "prey_species")
    taxo_base_name <- paste0(role, "_base_name")
    
    # get taxonomy
    taxonomy <- worrms_validate(data[[data_base_name]]) %>%
        validate_taxonomy() %>% 
        stats::setNames(paste0(role, '_', names(.)))
    names(taxonomy)[names(taxonomy) == taxo_base_name] <- data_base_name
    
    # join
    dplyr::left_join(data, taxonomy)
}