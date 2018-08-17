
#' Launch interactive manual recode table
#'
#' Create and launch an editable interactive manual recoding look up table. 
#' Edit entries and export to a variety of formats. Tables can be used to join manual
#' corrections or through functions like `plyr::revalue`
#' @param df a data.frame or tibble
#' @param recode_var the unquoted name of the column for which recoding is required
#' @param pattern optional character string of regex pattern to match. 
#' Matches are highlighted in the `pattern` column
#'
#' @return an html editable table widget of the selected variable and an editable 
#' recode column.
#' @export
#'
#' @examples
#' \dontrun{
#' mn_recode_tbl(mtcars, cyl)
#' mn_recode_tbl(mtcars, cyl, "4")
#' }
mn_recode_tbl <- function(df, recode_var, pattern = NULL){
    
    recode_var <- dplyr::enquo(recode_var)
    df %>% 
        select(!! recode_var) %>% 
        distinct() %>% 
        mutate(rename = !! recode_var, 
               pattern = if(is.null(pattern)){FALSE}else{
                   stringr::str_detect(!! recode_var, pattern)}) %>%
        # render data table
        DT::datatable(class = 'cell-border stripe', rownames = F, 
                      editable = T,
                      extensions = c('Buttons','KeyTable'),
                      options = list(
                          dom = 'Bfrtip',
                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                          keys = TRUE)
                      )  %>%
       DT::formatStyle(
            'pattern',
            backgroundColor = DT::styleEqual(
                c(0, 1), c('white', 'lightpink')
            )
        )
}


#' Recode the values in the column of a data.frame using a manual recode table
#'
#' @param df a data.frame in which column values are to be recoded.
#' @param recode_tbl a manual recoding table, as output from `mn_recode_tbl()`
#' @param recode_target character string. The name of the column to be recoded
#' if it differs from the first named column of `recode_tbl`
#'
#' @return the orgininal `df` with values in the `recode_target` column recode using
#' look up vales in `recode_tbl`
#' @export
mn_recode <- function(df, recode_tbl, recode_target = NULL){
    recode_var <- names(recode_tbl)[1]
    if(is.null(recode_target)){recode_target <- recode_var}
    recode <- recode_tbl[, recode_var, drop = T] %>% 
        setNames(recode_tbl$rename, .)
    message("Recoding target var: ", recode_target, "\n")
    df[,recode_target] <- plyr::revalue(df[,recode_target, drop = T], recode)
    df
}


#' Launch interactive editable table
#'
#' @param df data.frame to edit
#'
#' @return an html editable table widget of `df`
#' @export
#'
#' @examples
#' \dontrun{
#' mn_edit_df(mtcars)
#' }
mn_edit_df <- function(df){
    DT::datatable(df, class = 'cell-border stripe', rownames = F, 
                  editable = T,
                  extensions = c('Buttons','KeyTable'),
                  options = list(
                      dom = 'Bfrtip',
                      buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                      keys = TRUE)
    )
}
