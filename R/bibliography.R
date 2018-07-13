

get_dois <- function(seabirddiet){
    refs <- seabirddiet$reference %>% 
        unique() %>% 
        stringr::str_replace(stringr::regex("Exp.", ignore.case= T), 
                             "Experimental.")
    
    #refs <- refs[1:3]
    dois <- refs %>% purrr::map_df(
        ~rcrossref::cr_works(flq = c(query.bibliographic = .x),
                             limit = 1, 
                             .progress="text",
                             sort = "score")$data)
    
    ref_tbl <- bind_cols(tibble(reference = refs), dois) %>% 
        left_join(distinct(seabirddiet, reference, source),
                  by = "reference")
    
}


get_ref_code <- function(x, type = c("ref_tab", "raw"), width = 3){
    type <- match.arg(type)
    prefix <- switch(type,
                     "ref_tab" = "REF",
                     "raw" = "RAW")
    glue::glue("{prefix}{stringr::str_pad(x, {width}, pad = 0)}")
}


extr_auth <- function(x){
    stringr::str_extract(x, "^[^[:digit:]]+") %>% 
        stringr::str_trim()}

extr_year <- function(x){
    stringr::str_extract(x, "[:digit:]{4}+") %>% 
        stringr::str_trim()}

extr_container <- function(x){
    stringr::str_extract(x, "(?<=[:digit:]) [^[:digit:]]+") %>% 
        stringr::str_trim() %>% stringr::str_replace(", No.", "") 
}

extr_pages <- function(x){
    stringr::str_extract(x, "([:digit:]+-[:digit:]+)") %>% 
        stringr::str_trim() 
}


get_crfields_table <- function(refs){
    tibble(reference = refs) %>%
        mutate(author = extr_auth(reference),
               year = extr_year(reference),
               container = extr_container(reference),
               pages = extr_pages(reference))
}

crq_query_fail <- function(x){
    tibble::tibble(reference = x$reference, 
                   author = NA,
                   author_f = NA,
                   year = NA,
                   container = NA,
                   volume = NA,
                   issue = NA,
                   pages = NA,
                   doi = NA,
                   title = NA
    )
}

crq_query_extr <- function(x, q){
    tibble::tibble(
        reference = x$reference, 
        author = crq_auth_conc(q$author),
        author_f = crq_auth_first(q$author),
        year = lubridate::as_date(q$created) %>% 
            lubridate::year(),
        container = q$container.title,
        volume = if(any(names(q) %in% "volume")){q$volume}else{NA},
        issue = if(any(names(q) %in% "issue")){q$issue}else{NA},
        pages = q$page,
        doi = q$doi,
        title = q$title,
        r_author = x$author,
        r_author_f = stringr::word(x$author, 1, 1),
        r_year = lubridate::as_date(x$year, format = "%Y", 
                                    tz = "GMT") %>% 
            lubridate::year(),
        r_container = x$container,
        r_pages = x$pages)
}   

crq_auth_conc <- function(author){
    author %>% purrr::map_chr(~.x %>% pull(family) %>% paste0( collapse = "; "))
}

crq_auth_first <- function(author){
    author %>% purrr::map_chr(~.x %>% filter(sequence == "first") %>% 
                                  slice(1) %>% pull(family))
}

crq_validate_ref <- function(q.out){
    q.out %>% filter(r_author_f == author_f, 
                     r_year == year,
                     #r_pages == pages
    )
}


query_works <- function(x, limit = 5){
    q <- rcrossref::cr_works(
        flq = c(`query.container-title` = x$container[1],
                query.author = x$author[1],
                query.bibliographic =  lubridate::as_date(as.numeric(x$year[1]))),
        limit = limit)$data
    
    if(nrow(q) == 0){
        return(crq_query_fail(x))
    }
    
    q.extr <-  crq_query_extr(x, q) %>% 
        crq_validate_ref()
    
    if(nrow(q.extr) == 0){
        return(crq_query_fail(x))
    }else{
        q.extr %>% select(-starts_with("r_")) 
    }
}