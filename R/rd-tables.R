#' insert interactive table in html rd. 
#' 
#' @param df data.frame to 
#'
#' @param width width of data.frame
#' @param ... additional arguments passed to datatable
#'
#' @importFrom DT datatable
#' @export
rd_datatable <- function(df, width = "100%", ...) {
    wrap_widget(datatable(df, width = width, ...))
}

#' @importFrom stringi stri_subset_regex
#' @importFrom htmlwidgets saveWidget
wrap_widget <- function(widget) {
    tmp <- tempfile(fileext = ".html")
    htmlwidgets::saveWidget(widget, tmp)
    widg <- paste(
        stringi::stri_subset_regex(readLines(tmp),
                                   "^</?(!DOCTYPE|meta|body|html|head|title)",
                                   negate = TRUE),
        collapse = "\n")
    paste("\\out{", escape_rd(widg), "}\n", sep = "\n")
}

#' @importFrom stringi stri_replace_all_fixed
escape_rd <- function(x) {
    stri_replace_all_fixed(
        stri_replace_all_fixed(
            stri_replace_all_fixed(
                stri_replace_all_fixed(x, "\\", "\\\\"),
                "%", "\\%"
            ),
            "{", "\\{"
        ),
        "}", "\\}"
    )
}

# From https://cran.r-project.org/web/packages/roxygen2/vignettes/formatting.html#tables

tabular <- function(df, col_names = TRUE, ...) {
    stopifnot(is.data.frame(df))

    align <- function(x) if (is.numeric(x)) "r" else "l"
    col_align <- vapply(df, align, character(1))

    cols <- lapply(df, format, ...)
    contents <- do.call(
        "paste",
        c(cols, list(sep = " \\tab ", collapse = "\\cr\n  "))
    )

    if (col_names) {
        header <- paste0("\\bold{", colnames(df), "}", collapse = " \\tab")
        contents <- paste0(header, "\\cr\n  ", contents)
    }

    paste(
        "\\tabular{", paste(col_align, collapse = ""), "}{\n  ",
        contents, "\n}\n",
        sep = ""
    )
}
