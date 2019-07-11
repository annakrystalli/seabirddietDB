#' Plot predators
#' 
#' Plot an interactive leaflet map of preadetor diet composition.
#' @param base_map 
#'
#' @inheritParams sbd_filter
#' @return plots an interactive leaflet map of the selected data
#' @export
#'
#' @examples
#' sbd_plot_predators(year = 1973)
#' @import leaflet
sbd_plot_predators <- function(df = seabirddietDB::seabirddiet, pred_species = NULL, prey_taxon = NULL, 
                     year = NULL, metrics = "freq_occ", base_map = "Stamen.Watercolor"){
    
    df <- df %>% sbd_filter(pred_species = pred_species, prey_taxon = prey_taxon, 
                            year = year, 
                            metrics = metrics) %>%
        dplyr::select(dplyr::one_of(c("year", "latitude", "longitude", "pred_species", 
                                      "prey_taxon", metrics))) %>%
        dplyr::group_by(.data$year, .data$latitude, .data$longitude, .data$pred_species) %>%
        dplyr::arrange(.data$year, .data$latitude, .data$longitude, .data$pred_species,
                       dplyr::desc(.data[[metrics[1]]])) %>%
        tidyr::nest(.key = "tabulate")
    
    factpal <- colorFactor(rainbow(length(unique(df$pred_species))), df$pred_species)
    
    leaflet(data = df) %>% addProviderTiles(base_map) %>%
        addCircleMarkers(
            color = ~factpal(pred_species),
            stroke = FALSE, fillOpacity = 0.7,
            popup = make_popup(df),
            clusterOptions = markerClusterOptions()) %>%
        addLegend("bottomright", pal = factpal, values = ~pred_species,
                  title = "predators",
                  opacity = 1)
}


make_popup <- function(df){
    popup_row <- function(x){paste("<strong> Predator: </strong>", x["pred_species"]," <br>", 
                                   "<strong> Year: </strong>", x["year"], "<br>",
                                   knitr::kable(x["tabulate"], 
                                                format = "html"))}
    apply(df, 1, popup_row)
}