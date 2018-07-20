
<!-- README.md is generated from README.Rmd. Please edit that file -->
seabirdPrey
===========

The goal of seabirdPrey is to ...

Goals
-----

-   \[x\] assess data
    -   \[ \] raise issues
    -   \[ \] report on data characteristics
    -   \[ \]
-   \[ \] Validate data
    -   \[ \] compose validation tests
-   \[ \] create metadata
    -   \[x\] taxonomic
    -   \[x\] references
    -   \[ \] attributes
    -   \[x\] creators
    -   \[ \] bibliography
    -   \[ \] method
    -   \[ \] abstract
-   \[ \] create EML (`eml2`)
    -   \[ \] create `eml`
    -   \[ \] create webpage with `emldown`
-   \[ \] publish csv on KNIB
-   \[ \] publish data r package
    -   \[ \] get it reviewed for rOpenSci
-   \[ \] shiny app for data exploration
-   \[ \] r data package?

------------------------------------------------------------------------

### Repo contents

    .
    ├── DESCRIPTION
    ├── NAMESPACE
    ├── R -> High level functions
    │   ├── bibliography.R
    │   ├── eml.R
    │   ├── process-data.R
    │   ├── taxonomy.R
    │   └── utils-pipe.R
    ├── README.Rmd
    ├── README.md
    ├── _workflowr.yml
    ├── analysis -> Website files including workbooks
    │   ├── 03_data-validation.Rmd
    │   ├── _site.yml
    │   ├── about.Rmd
    │   ├── index.Rmd
    │   ├── license.Rmd
    │   ├── reference_processing.Rmd
    │   ├── reference_processing.nb.html
    │   ├── reference_processing_cache
    │   │   └── html
    │   ├── taxonomic_processing.Rmd
    │   └── taxonomic_processing_cache
    │       └── html
    ├── code -> miscellaneous scripts
    │   ├── README.md
    │   ├── dev.R
    │   ├── diet_diversity.R
    │   ├── from_ruedi
    │   │   └── bird_data_workflow.R
    │   └── from_tom
    ├── data
    │   ├── metadata -> metadata files used to create eml
    │   │   ├── access.csv
    │   │   ├── attributes.csv
    │   │   ├── biblio.csv
    │   │   ├── creators.csv
    │   │   ├── methods.txt
    │   │   ├── references.csv
    │   │   └── taxonomy.csv
    │   └── seabirddiet.rda -> final data set in .rda format (package dataset)
    ├── data-raw -> processing scripts
    │   ├── 01_data-process.R
    │   ├── 01b_data-process_taxonomy.R
    │   ├── 01c_process_references.R
    │   ├── 02_create_metadata.R
    │   ├── 03_save_data.R
    │   ├── 04_eml.R
    │   ├── Seabird Diets British Isles revised 20180620.csv
    │   ├── from_ruedi -> data from Ruedi
    │   │   ├── Seabird Diet Database Documentation.docx
    │   │   ├── Seabird Diets British Isles revised 20180524.xlsx
    │   │   └── prey species list.csv
    │   ├── from_tom -> data from Tom
    │   │   ├── Master File 20171020.xlsx
    │   │   ├── README MERP Seabird Diet Database v2018-06.rtf
    │   │   ├── prey species list.xlsx
    │   │   └── taxon_name_guideline.xlsx
    │   ├── joins -> metadata tables to join to final data.
    │   │   └── ref_join.csv
    │   ├── taxonomy.tsv -> taxonomy raw table.
    │   ├── validation -> tables required for validation
    │   │   ├── 2018-06-22_worrms_nomatches.csv
    │   │   ├── foo_unvalidated.csv
    │   │   └── reference_manual_clean.csv
    │   └── worrms_nomatches_verified.csv -> manual taxonomic corrections table
    ├── docs
    │   ├── about.html
    │   ├── index.html
    │   ├── license.html
    │   ├── reference_processing.html
    │   ├── site_libs -> libraries required for the website
    │   │   ├── ...
    │   └── taxonomic_processing.html
    ├── inst -> folder of files to be included in package when installed
    │   └── testdata -> data for testing
    │       ├── data.csv
    │       ├── taxonomy.tsv
    │       └── worrms_nomatches_verified.csv
    ├── man
    │   ├── get_join_ref.Rd
    │   ├── get_ref_tbl.Rd
    │   ├── pipe.Rd
    │   ├── tidy_refs.Rd
    │   └── yr_to_isorange.Rd
    ├── output -> folder containing final csv output
    │   └── README.md
    ├── seabirdPrey.Rproj
    └── tests -> testing folder
        ├── testthat
        │   ├── setup.R
        │   ├── test-data-process.R
        │   ├── test-eml.R
        │   └── test-taxonomy.R
        └── testthat.R
