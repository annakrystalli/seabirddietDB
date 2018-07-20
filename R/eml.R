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
