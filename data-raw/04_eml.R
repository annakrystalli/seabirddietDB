library(dplyr)
library(EML)
library(metadatar)
library(seabirdPrey)

# load-final-data ----
data(seabirddiet)

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
coverage <- 
    set_coverage(begin = seabirdPrey:::yr_to_isorange(seabirddiet$startyear, 
                                              type = "start"), 
                       end = seabirdPrey:::yr_to_isorange(seabirddiet$endyear, 
                                            type = "end"),
                       sci_names = readr::read_csv(
                           here::here("data", "metadata", "taxonomy.csv")) %>% 
                           dplyr::select(phylum:species) %>% as.data.frame(),
                       geographicDescription = geographicDescription,
                       west = bbox["xmin"], east = bbox["xmax"], 
                       north = bbox["ymax"], south = bbox["ymin"],
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
        keywordThesaurus = "LTER controlled vocabulary",
        keyword = list("Marine birds",
                       "Diets",
                       "Food composition",
                       "Predators",
                       "Prey selection",
                       "Predation",
                       "Forage species")
    ),
    list(
        keywordThesaurus = "LTER core area",
        keyword =  list("populations", "inorganic nutrients", "disturbance")
    ),
    list(
        keywordThesaurus = "HFR default",
        keyword = list("Harvard Forest", "HFR", "LTER", "USA")
    ))


# set-creators
creators_df <- readr::read_csv(here::here("data-raw", "metadata",
                                          "creators.csv"))



creators_l <- creators_df %>% apply(1, extr_creator)






publisher <- eml$publisher(
    organizationName = "Harvard Forest",
    address = HF_address)

contact <- 
    list(
        individualName = aaron$individualName,
        electronicMailAddress = aaron$electronicMailAddress,
        address = HF_address,
        organizationName = creators_df$affilitation)

# set-attributes ----
set_attributes()

# set-attributes ----


sbd_eml <- eml$eml(
    packageId = uuid::UUIDgenerate(),  
    system = "uuid",
    dataset = eml$dataset(
        title = "Seabird Diet Database",
        creator = creators_l,
        pubDate = "2018",
        intellectualRights = "http://www.lternet.edu/data/netpolicy.html.",
        abstract = abstract,
        keywordSet = keywordSet,
        coverage = coverage,
        contact = contact,
        methods = methods,
        dataTable = eml$dataTable(
            entityName = "seabirddiet.csv",
            entityDescription = "Seabird Diet Database",
            physical = physical,
            attributeList = attributeList)
    ))
