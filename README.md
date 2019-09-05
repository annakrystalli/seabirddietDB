
<!-- README.md is generated from README.Rmd. Please edit that file -->

# seabirddietDB

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/annakrystalli/seabirddietDB.svg?branch=master)](https://travis-ci.org/annakrystalli/seabirddietDB)
[![Codecov test
coverage](https://codecov.io/gh/annakrystalli/seabirddietDB/branch/master/graph/badge.svg)](https://codecov.io/gh/annakrystalli/seabirddietDB?branch=master)
<!-- badges: end -->

The goal of seabirddietDB is to provide access and tools to interact
with a databse of seabird diets around the British Isles

## Installation

You can install the released version of seabirddietDB from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("seabirddietDB")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("annakrystalli/seabirddietDB")
```

## Example

To access the data simply load the package. The data is then available

``` r
library(seabirddietDB)
```

``` r
class(seabirddiet)
#> [1] "tbl_df"     "tbl"        "data.frame"
```

``` r
seabirddiet
```

    #> # A tibble: 2,857 x 33
    #>       id pred_common_name pred_species  year startyear endyear multiyear
    #>    <int> <chr>            <chr>        <dbl>     <dbl>   <dbl> <lgl>    
    #>  1     1 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
    #>  2     2 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
    #>  3     3 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
    #>  4     4 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
    #>  5     5 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
    #>  6     6 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
    #>  7     7 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
    #>  8     8 Atlantic puffin  Fratercula …  1983      1983    1983 FALSE    
    #>  9     9 Atlantic puffin  Fratercula …  1983      1983    1983 FALSE    
    #> 10    10 Atlantic puffin  Fratercula …  1983      1983    1983 FALSE    
    #> # … with 2,847 more rows, and 26 more variables: location <chr>,
    #> #   latitude <dbl>, longitude <dbl>, pred_breeding_status <chr>,
    #> #   pred_age_group <chr>, prey_orig_descr <chr>, prey_taxon <chr>,
    #> #   freq_occ <dbl>, freq_num <dbl>, freq_biomass <dbl>, prey_size <chr>,
    #> #   sample_size <dbl>, sample_type <chr>, source <chr>, notes <chr>,
    #> #   prey_age_group <chr>, pred_rank <chr>, pred_aphia_id <int>,
    #> #   pred_valid_name <chr>, pred_valid_aphia_id <int>, prey_rank <chr>,
    #> #   prey_aphia_id <int>, prey_valid_name <chr>, prey_valid_aphia_id <int>,
    #> #   ref_n <dbl>, ref_ids <chr>

``` r
class(seabirddiet)
#> [1] "tbl_df"     "tbl"        "data.frame"
```

A version with more formal data types/structures in the columns (ie
geographic information stored as `sf`, categorical data as factors etc)
is also available

``` r
class(seabirddiet_)
```

## Helpers

### List

List predators

``` r
sbd_predators()
#> [1] "Alca torda"                "Fratercula arctica"       
#> [3] "Fulmarus glacialis"        "Morus bassanus"           
#> [5] "Phalacrocorax aristotelis" "Puffinus puffinus"        
#> [7] "Rissa tridactyla"          "Uria aalge"
```

List prey

``` r
sbd_prey(verbose = TRUE)
#> # A tibble: 129 x 5
#>    prey_taxon    prey_rank prey_aphia_id prey_valid_name   prey_valid_aphi…
#>    <chr>         <chr>             <int> <chr>                        <int>
#>  1 Acanthephyra  genus            107018 Acanthephyra                107018
#>  2 Acanthephyra… species          107581 Acanthephyra pel…           107581
#>  3 Actinopteryg… class             10194 Actinopterygii               10194
#>  4 Agonidae      family           125588 Agonidae                    125588
#>  5 Agonus catap… species          127190 Agonus cataphrac…           127190
#>  6 Alloteuthis … species          153131 Alloteuthis subu…           153131
#>  7 Ammodytes la… species          146485 Hyperoplus lance…           126756
#>  8 Ammodytes ma… species          126751 Ammodytes marinus           126751
#>  9 Ammodytes to… species          126752 Ammodytes tobian…           126752
#> 10 Ammodytidae   family           125516 Ammodytidae                 125516
#> # … with 119 more rows
```

### Filter data

#### filter predator

``` r
sbd_filter(pred_species = "Fratercula arctica")
#> # A tibble: 615 x 33
#>       id pred_common_name pred_species  year startyear endyear multiyear
#>    <int> <chr>            <chr>        <dbl>     <dbl>   <dbl> <lgl>    
#>  1     1 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  2     2 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  3     3 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  4     4 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  5     5 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  6     6 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  7     7 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  8     8 Atlantic puffin  Fratercula …  1983      1983    1983 FALSE    
#>  9     9 Atlantic puffin  Fratercula …  1983      1983    1983 FALSE    
#> 10    10 Atlantic puffin  Fratercula …  1983      1983    1983 FALSE    
#> # … with 605 more rows, and 26 more variables: location <chr>,
#> #   latitude <dbl>, longitude <dbl>, pred_breeding_status <chr>,
#> #   pred_age_group <chr>, prey_orig_descr <chr>, prey_taxon <chr>,
#> #   freq_occ <dbl>, freq_num <dbl>, freq_biomass <dbl>, prey_size <chr>,
#> #   sample_size <dbl>, sample_type <chr>, source <chr>, notes <chr>,
#> #   prey_age_group <chr>, pred_rank <chr>, pred_aphia_id <int>,
#> #   pred_valid_name <chr>, pred_valid_aphia_id <int>, prey_rank <chr>,
#> #   prey_aphia_id <int>, prey_valid_name <chr>, prey_valid_aphia_id <int>,
#> #   ref_n <dbl>, ref_ids <chr>
```

#### filter metrics

``` r

sbd_filter(pred_species = "Fratercula arctica", metrics = "freq_biomass")
#> # A tibble: 219 x 31
#>       id pred_common_name pred_species  year startyear endyear multiyear
#>    <int> <chr>            <chr>        <dbl>     <dbl>   <dbl> <lgl>    
#>  1   291 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  2   292 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  3   293 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  4   298 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  5   299 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  6   300 Atlantic puffin  Fratercula …  1974      1974    1974 FALSE    
#>  7   301 Atlantic puffin  Fratercula …  1974      1974    1974 FALSE    
#>  8   308 Atlantic puffin  Fratercula …  1974      1974    1974 FALSE    
#>  9   309 Atlantic puffin  Fratercula …  1974      1974    1974 FALSE    
#> 10   310 Atlantic puffin  Fratercula …  1975      1975    1975 FALSE    
#> # … with 209 more rows, and 24 more variables: location <chr>,
#> #   latitude <dbl>, longitude <dbl>, pred_breeding_status <chr>,
#> #   pred_age_group <chr>, prey_orig_descr <chr>, prey_taxon <chr>,
#> #   freq_biomass <dbl>, prey_size <chr>, sample_size <dbl>,
#> #   sample_type <chr>, source <chr>, notes <chr>, prey_age_group <chr>,
#> #   pred_rank <chr>, pred_aphia_id <int>, pred_valid_name <chr>,
#> #   pred_valid_aphia_id <int>, prey_rank <chr>, prey_aphia_id <int>,
#> #   prey_valid_name <chr>, prey_valid_aphia_id <int>, ref_n <dbl>,
#> #   ref_ids <chr>
```

#### filter prey

``` r
sbd_filter(prey_taxon = c("Cottidae", "Actinopterygii"))
#> # A tibble: 124 x 33
#>       id pred_common_name pred_species  year startyear endyear multiyear
#>    <int> <chr>            <chr>        <dbl>     <dbl>   <dbl> <lgl>    
#>  1   360 Atlantic puffin  Fratercula …  1982      1982    1982 FALSE    
#>  2   366 Atlantic puffin  Fratercula …  1983      1983    1983 FALSE    
#>  3   374 Atlantic puffin  Fratercula …  1984      1984    1984 FALSE    
#>  4   899 Black-legged ki… Rissa trida…  1990      1990    1990 FALSE    
#>  5   911 Black-legged ki… Rissa trida…  1992      1992    1992 FALSE    
#>  6  1055 Black-legged ki… Rissa trida…  2006      2006    2006 FALSE    
#>  7  1197 Common guillemot Uria aalge    2009      2006    2011 TRUE     
#>  8  1201 Common guillemot Uria aalge    2009      2006    2011 TRUE     
#>  9  1214 Common guillemot Uria aalge    2009      2006    2011 TRUE     
#> 10  1218 Common guillemot Uria aalge    2009      2006    2011 TRUE     
#> # … with 114 more rows, and 26 more variables: location <chr>,
#> #   latitude <dbl>, longitude <dbl>, pred_breeding_status <chr>,
#> #   pred_age_group <chr>, prey_orig_descr <chr>, prey_taxon <chr>,
#> #   freq_occ <dbl>, freq_num <dbl>, freq_biomass <dbl>, prey_size <chr>,
#> #   sample_size <dbl>, sample_type <chr>, source <chr>, notes <chr>,
#> #   prey_age_group <chr>, pred_rank <chr>, pred_aphia_id <int>,
#> #   pred_valid_name <chr>, pred_valid_aphia_id <int>, prey_rank <chr>,
#> #   prey_aphia_id <int>, prey_valid_name <chr>, prey_valid_aphia_id <int>,
#> #   ref_n <dbl>, ref_ids <chr>
```

#### filter year

``` r
sbd_filter(year = 1973:1976)
#> # A tibble: 207 x 33
#>       id pred_common_name pred_species  year startyear endyear multiyear
#>    <int> <chr>            <chr>        <dbl>     <dbl>   <dbl> <lgl>    
#>  1     1 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  2     2 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  3     3 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  4     4 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  5     5 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  6     6 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  7     7 Atlantic puffin  Fratercula …  1973      1973    1973 FALSE    
#>  8    11 Atlantic puffin  Fratercula …  1974      1974    1974 FALSE    
#>  9    12 Atlantic puffin  Fratercula …  1974      1974    1974 FALSE    
#> 10    13 Atlantic puffin  Fratercula …  1974      1974    1974 FALSE    
#> # … with 197 more rows, and 26 more variables: location <chr>,
#> #   latitude <dbl>, longitude <dbl>, pred_breeding_status <chr>,
#> #   pred_age_group <chr>, prey_orig_descr <chr>, prey_taxon <chr>,
#> #   freq_occ <dbl>, freq_num <dbl>, freq_biomass <dbl>, prey_size <chr>,
#> #   sample_size <dbl>, sample_type <chr>, source <chr>, notes <chr>,
#> #   prey_age_group <chr>, pred_rank <chr>, pred_aphia_id <int>,
#> #   pred_valid_name <chr>, pred_valid_aphia_id <int>, prey_rank <chr>,
#> #   prey_aphia_id <int>, prey_valid_name <chr>, prey_valid_aphia_id <int>,
#> #   ref_n <dbl>, ref_ids <chr>
```

#### filter multiple

``` r
sbd_filter(year = 1973:1976, pred_species = "Uria aalge", prey_taxon = "Gadidae")
#> # A tibble: 3 x 33
#>      id pred_common_name pred_species  year startyear endyear multiyear
#>   <int> <chr>            <chr>        <dbl>     <dbl>   <dbl> <lgl>    
#> 1  1333 Common guillemot Uria aalge    1973      1973    1973 FALSE    
#> 2  1699 Common guillemot Uria aalge    1973      1973    1973 FALSE    
#> 3  1704 Common guillemot Uria aalge    1975      1975    1975 FALSE    
#> # … with 26 more variables: location <chr>, latitude <dbl>,
#> #   longitude <dbl>, pred_breeding_status <chr>, pred_age_group <chr>,
#> #   prey_orig_descr <chr>, prey_taxon <chr>, freq_occ <dbl>,
#> #   freq_num <dbl>, freq_biomass <dbl>, prey_size <chr>,
#> #   sample_size <dbl>, sample_type <chr>, source <chr>, notes <chr>,
#> #   prey_age_group <chr>, pred_rank <chr>, pred_aphia_id <int>,
#> #   pred_valid_name <chr>, pred_valid_aphia_id <int>, prey_rank <chr>,
#> #   prey_aphia_id <int>, prey_valid_name <chr>, prey_valid_aphia_id <int>,
#> #   ref_n <dbl>, ref_ids <chr>
```

### Plot data

There are additional helpers for interactive plotting of data

``` r
sbd_plot_predators(year = 1973)
#> Assuming "longitude" and "latitude" are longitude and latitude, respectively
```

<img src="man/figures/README-plot-year-1.png" width="100%" />
