#' Extract date ranges from a vector of years
#'
#' @param x vector of years
#' @param type what output to return. `both` for the range, 
#' `start` for only the start date, `end` for the end date
#'
#' @return years are converted to ISO dates of 1st Jan for a `begin` date
#' and 31st Dec for `end` dates. If `type = "range"` a vector of length 2 
#' is returned. Otherwise a named character string of the specified 
#' boundary is returned.
#' @export
#'
yr_to_isorange <- function(x, type = c("both", "start", "end")){
    type <- match.arg(type)
    range <- c(start = as.Date(ISOdate(min(x, na.rm = T), 
                                       1, 1)),
               end = as.Date(ISOdate(max(x, na.rm = T), 
                                     12, 31))
               )
    return(
        switch (type,
        "both" = range,
        "start" =  range["start"],
        "end" = range["end"])
        )
}


#' Extract creators to list format
#'
#' Function to be applied to the `creators_df` to exctract tabular information 
#' into creators format. 
#' @param x a row in the `creators_df` data.frame 
#' (read from `data-raw/metadata/creators.csv``)
#'
#' @return an eml creator list element
#' @export
extr_creator <- function(x){   
    eml_address <- EML::eml$address(
        deliveryPoint =  x["address"],
        administrativeArea = x["amdin_area"],
        country = x["country"])
    
    EML::eml$creator(
        individualName = EML::eml$individualName(
            givenName = x["givenName"],
            surName = x["familyName"]),
        electronicMailAddress = x["email"],
        userId = EML::eml$userId(
            directory = paste0("http://orcid.org/", x["ORCID-ID"])),
        address = eml_address,
        organizationName = x["affiliation"]
        )
}

#' Extract reference to list of eml citations format
#'
#' Function to be applied to the `references.csv` data.frame to exctract tabular information 
#' into a list of eml citation format for each reference. 
#' @param x a row in the `references` data.frame 
#' (read from `data-raw/metadata/references.csv`)
#'
#' @return an eml creator list element
#' @export
extr_citations <- function(x){
    list(citation = list(key = x["ref_id"],
                         unstructured_citation = x["ref_valid"]))
}