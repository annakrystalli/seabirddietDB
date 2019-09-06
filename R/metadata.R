#' Reference list
#'
#' Reference list linking the reference identifiers (\code{ref_id}) to the full reference 
#' they relate to (\code{ref_valid})
#'
#' @format A tibble with \Sexpr{nrow(seabirddietDB::references)} rows and \Sexpr{ncol(seabirddietDB::references)} variables
"references"

#' Attribute List
#'
#' Detailed attribute list of columns in \code{seabirddiet}. For further details on 
#' attribute fields see relevant \href{https://ropensci.github.io/EML/articles/creating-EML.html#attribute-metadata}{documentation}
#' in package \pkg{EML}.
#'
#' @format A tibble with \Sexpr{nrow(seabirddietDB::attributes)} rows and \Sexpr{ncol(seabirddietDB::attributes)} variables
"attributes"

#' Classification table
#'
#' Taxonomic classification table of prey and predator taxa contained in \code{seabirddiet} columns \code{pred_species} 
#' and \code{prey_taxon}. 
#'
#' @format A tibble with \Sexpr{nrow(seabirddietDB::classification)} rows and \Sexpr{ncol(seabirddietDB::classification)} variables
"classification"