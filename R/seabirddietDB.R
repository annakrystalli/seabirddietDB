#' \code{seabirddietDB} package
#'
#' Seabird Diet Database
#'
#' See the README on
#' \href{https://github.com/annakrystalli/seabirddietDB/blob/master/README.md}{GitHub}
#'
#' @docType package
#' @name seabirddietDB
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c(".data", "seabirddiet", "seabirddiet_", "rainbow"))