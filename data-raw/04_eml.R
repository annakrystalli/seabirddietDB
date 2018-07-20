library(dplyr)

# load-final-data ----
seabirddiet <- readr::read_csv(
    here::here("data-raw", 
               "Seabird Diets British Isles revised 20180620.csv")) %>% 
    janitor::clean_names() %>%
    bind_cols(ID =  1:nrow(.), .)

# latlon-to-sf ----
seabirddiet <- seabirddiet %>% 
    sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

# get-bbox ----
bbox <- sf::st_bbox(seabirddiet)


# set-geographic-description ----
geographicDescription <- "Studies come mainly from locations around the British 
Isles, but we also included relevant studies from the North Atlantic and very 
rarely for the Mediterranean and the Pacific where the same species also bred.
Sometimes samples were taken over a wider region and where it was not 
distinguished between two or more specific locations where diet samples were collected we took approximately the midpoint between multiple locations where relevant."


# set-coverage-description ----
coverage <- 
    eml2::set_coverage(begin = yr_to_isorange(seabirddiet$startyear, 
                                        type = "start"), 
                 end = yr_to_isorange(seabirddiet$endyear, 
                                      type = "end"),
                 sci_names = readr::read_csv(
                     here::here("data", "metadata", "taxonomy.csv")),
                 geographicDescription = geographicDescription,
                 west = bbox["xmin"], east = bbox["xmax"], 
                 north = bbox["ymax"], south = bbox["ymin"],
                 altitudeMin = 0, altitudeMaximum = 0,
                 altitudeUnits = "meter")



# set-method ----
methods_file <- system.file("examples/hf205-methods.docx", package = "EML")
methods <- set_methods(methods_file)


# set-abstract ----
abstract_file <-  system.file("examples/hf205-abstract.md", package = "EML")
abstract <- set_TextType(abstract_file)

# set-attributes ----
set_attributes()

# set-attributes ----






my_eml <- eml$eml(
    packageId = uuid::UUIDgenerate(),  
    system = "uuid",
    dataset = eml$dataset(
        title = "Seabird diets",
        creator = aaron,
        pubDate = "2018",
        intellectualRights = "http://www.lternet.edu/data/netpolicy.html.",
        abstract = abstract,
        keywordSet = keywordSet,
        coverage = coverage,
        contact = contact,
        methods = methods,
        dataTable = eml$dataTable(
            entityName = "seabirddiet.csv",
            entityDescription = "tipping point experiment 1",
            physical = physical,
            attributeList = attributeList)
    ))