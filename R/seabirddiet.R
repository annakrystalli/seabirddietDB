#' Seabird marine prey database
#'
#' A dataset containing information on prey consumed by seabirds breeding in the 
#' British Isles.
#'
#' The data are published on the KNB under DOI xxxxxxxxxxx.
#' \if{html}{
#'   \Sexpr[echo=FALSE, results=rd, stage=build]{
#'   in_pkgdown <- any(grepl("as_html.tag_Sexpr", sapply(sys.calls(), function(a) paste(deparse(a), collapse = "\n"))))
#'     if(in_pkgdown) {
#'       mytext <- c('In RStudio, this help file includes a searchable table of values.')
#'     } else {
#'       mytext <- c("\n Note: the table may not render correctly in the RStudio dark theme. To view, open in a new window", 
#'       seabirddietDB::rd_datatable(readr::read_csv(system.file("metadata", "attributes.csv", 
#'       package = "seabirddietDB"), col_types = readr::cols()), class = "row-border", rownames=FALSE))
#'     }
#'     mytext
#'   }
#' }
#'
#' \if{text,latex}{The HTML version of this help file includes a searchable table of 
#' the dataset attributes.}
#'
#' @format A tibble with \Sexpr{nrow(seabirddietDB::seabirddiet)} rows and \Sexpr{ncol(seabirddietDB::seabirddiet)} variables
#' @source \url{xxxxxx}
#' @seealso [seabirddiet_] 
"seabirddiet"


#' @inherit seabirddiet 
#' @format A tibble with \Sexpr{nrow(seabirddietDB::seabirddiet)} rows and
#'  \Sexpr{ncol(seabirddietDB::seabirddiet) - 1} variables. 
#'  The dataset is of class \code{sf} with geographic information stored in the  \code{geometry} column. 
#'  Factor variables are stored as such.
#' @source \url{xxxxxx}
"seabirddiet_"