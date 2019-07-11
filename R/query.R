#' Filter Seabird Diet database
#'
#' @param db Seabird Diet database to filter. Defaults to `seabirddiet`
#' @param pred_species character vector. Predator species to include
#' @param prey_taxon character vector. Prey taxa to include
#' @param year integer vector. Year(s) to include
#' @param metrics which dietary metrics to include. Defaults to frequency of occurence (`freq_occ`)
#'
#' @return a filtered tibble of the supplied database
#' @export
#'
#' @examples
#' sbd_filter(year = 2012)
#' sbd_filter(pred_species = "Alca torda", year = 2012)
sbd_filter <- function(db = seabirddietDB::seabirddiet, pred_species = NULL, prey_taxon = NULL,
                       year = NULL, metrics = c("freq_occ", "freq_biomass", "freq_num")) {
  if (!is.null(pred_species)) {
    pred_species <- match.arg(pred_species,
      choices = unique(seabirddiet$pred_species),
      several.ok = TRUE
    )

    db <- dplyr::filter(db, .data$pred_species %in% pred_species)
  }
  if (!is.null(prey_taxon)) {
    prey_taxon <- match.arg(prey_taxon, choices = unique(seabirddiet$prey_taxon), several.ok = TRUE)
    db <- dplyr::filter(db, .data$prey_taxon %in% prey_taxon)
  }
  if (!is.null(year)) {
    #year <- match.arg(year, choices = unique(seabirddiet_$year), several.ok = TRUE)
    db <- dplyr::filter(db, .data$year %in% year)
  }
  metrics <- match.arg(metrics, several.ok = TRUE)
  db <- dplyr::select(db, .data$pred_species, .data$prey_taxon, .data$year,  
                      dplyr::one_of("location", "latitude", "longitude", "geometry"),
                      dplyr::one_of(metrics)) %>%
    dplyr::filter(as.logical(rowSums(!is.na(dplyr::select(db, dplyr::one_of(metrics))))))

  db
}


#' Print table of Predators
#'
#' @inheritParams sbd_filter
#' @param verbose logical. Whether to include taxonomic in the print out
#' 
#' @return if `verbose = FALSE` (default), function returns a sorted character 
#' vector of all prey taxa. If `verbose = TRUE`, returns a tibble with information on prey
#' @export
#'
#' @examples
#' sbd_predators()
#' sbd_predators(verbose = TRUE)
sbd_predators <- function(db = seabirddietDB::seabirddiet, verbose = FALSE) {
    if (verbose) {
        db %>%
            dplyr::select(.data$pred_species, .data$pred_rank, .data$pred_aphia_id, 
                          .data$pred_valid_name, .data$pred_valid_aphia_id) %>%
            dplyr::distinct() %>%
            dplyr::arrange(.data$pred_species)
    } else {
        sort(unique(db$pred_species))
    }
}


#' Print Prey information
#'
#' @inheritParams sbd_filter
#' @inheritParams sbd_predators
#' @return if `verbose = FALSE` (default), function returns a sorted character 
#' vector of all prey taxa. If `verbose = TRUE`, returns a tibble with information on prey
#' @export
#'
#' @examples
#' sbd_prey()
#' sbd_prey(verbose = TRUE)
sbd_prey <- function(db = seabirddietDB::seabirddiet, verbose = FALSE) {
  if (verbose) {
    db %>%
      dplyr::select(.data$prey_taxon, .data$prey_rank, .data$prey_aphia_id, 
                    .data$prey_valid_name, .data$prey_valid_aphia_id) %>%
      dplyr::distinct() %>%
      dplyr::arrange(.data$prey_taxon)
  } else {
    sort(unique(db$prey_taxon))
  }
}
