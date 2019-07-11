library(dplyr)
library(EML)
library(metadatar)
library(seabirdPrey)
library(seabirddiet.devtools)

# load-final-data ----
data(seabirddiet_)

# set-attributes ----
meta_tbl <- readr::read_csv(
    here::here("data-raw", "metadata", "attributes.csv"))
factors <- metadatar::mt_extract_factors_tbl(meta_tbl) 
attr_tbl <- metadatar::mt_extract_attr_tbl(meta_tbl)

attribute_list <- set_attributes(attributes = attr_tbl,
                    factors = factors,
                    col_classes = meta_tbl$columnClasses)

# set physical ----
physical <- set_physical("inst/csv/seabirddiet.csv")

# latlon-to-sf ----
# get-bbox ----
bbox <- sf::st_bbox(seabirdPrey::seabirddiet_)


# set-geographic-description ----
geographicDescription <- "Studies come mainly from locations around the British 
Isles, but we also included relevant studies from the North Atlantic and very 
rarely for the Mediterranean and the Pacific where the same species also bred.
Sometimes samples were taken over a wider region and where it was not 
distinguished between two or more specific locations where diet samples were collected we took approximately the midpoint between multiple locations where relevant."


# set-coverage-description ----
classification <- readr::read_csv(
    here::here("data-raw", "metadata", "classification.csv")) %>% 
    dplyr::select(phylum:species) %>% as.data.frame()

coverage <- 
    set_coverage(begin = yr_to_isorange(seabirddiet$startyear, 
                                              type = "start"), 
                       end = yr_to_isorange(seabirddiet$endyear, 
                                            type = "end"),
                       sci_names = classification,
                       geographicDescription = geographicDescription,
                       west = bbox["ymin"], east = bbox["ymax"], 
                       north = bbox["xmax"], south = bbox["xmin"],
                       altitudeMin = 0, altitudeMaximum = 0,
                       altitudeUnits = "meter")



# set-method ----
methods_file <- here::here("data-raw", "metadata","methods.docx")
methods <- set_methods(methods_file)


# set-abstract ----
abstract_file <-  here::here("data-raw", "metadata","abstract.docx")
abstract <- set_TextType(abstract_file)


# set-keywords
keywordSet <- list(
    list(
        keywordThesaurus = "Aquatic Sciences and Fisheries Thesaurus - FAO",
        keyword = list("Marine birds",
                       "Diets",
                       "Food composition",
                       "Predators",
                       "Prey selection",
                       "Predation",
                       "Forage species",
                       "Niches",
                       "Food webs")
    ))


# set-creators ----
creators_df <- readr::read_csv(here::here("data-raw", "metadata",
                                          "creators.csv")) %>%
    dplyr::mutate(admin_area = "Scotland", country = "UK")
creators_l <- creators_df %>% apply(1, extr_creator)
contact <- creators_l[[1]]
#creators_l[[1]] <- NULL

# set-references ----
citation_list <- citation_list_make()



# set-publisher ----
publisher <- eml$publisher(
    organizationName = "Marine Ecosystems Research Programme",
    address = eml$address(
        deliveryPoint = "Plymouth Marine Laboratory, Prospect Place",
        city = "Plymouth",
        administrativeArea = "Devon",
        postalCode = "PL1 3DH",
        country = "UK"))

# create-eml ----
sbd_eml <- eml$eml(
    packageId = uuid::UUIDgenerate(),  
    system = "uuid",
    dataset = eml$dataset(
        id = "dat.001",
        title = "Seabird Diet Database",
        creator = creators_l,
        pubDate = "2018",
        intellectualRights = "https://creativecommons.org/licenses/by/3.0/",
        abstract = abstract,
        keywordSet = keywordSet,
        coverage = coverage,
        contact = contact,
        methods = methods,
        dataTable = eml$dataTable(
            entityName = "seabirddiet.csv",
            entityDescription = "Seabird Diet Database",
            physical = physical,
            attributeList = attribute_list)),
    additionalMetadata = eml$additionalMetadata(
        describes = "dat.001",
        metadata = citation_list)
    )

# validate eml ----
eml_validate(sbd_eml)

# write eml ----
write_eml(sbd_eml, file = here::here("inst", "metadata", "seabirddiet_eml"))

# create emldown page ----
emldown::render_eml(here::here("inst", "metadata", "seabirddiet_eml"), outfile = "index.html")
