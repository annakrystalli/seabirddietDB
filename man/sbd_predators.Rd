% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query.R
\name{sbd_predators}
\alias{sbd_predators}
\title{Print table of Predators}
\usage{
sbd_predators(db = seabirddietDB::seabirddiet, verbose = FALSE)
}
\arguments{
\item{db}{Seabird Diet database to filter. Defaults to `seabirddiet`}

\item{verbose}{logical. Whether to include taxonomic in the print out}
}
\value{
if `verbose = FALSE` (default), function returns a sorted character 
vector of all prey taxa. If `verbose = TRUE`, returns a tibble with information on prey
}
\description{
Print table of Predators
}
\examples{
sbd_predators()
sbd_predators(verbose = TRUE)
}
