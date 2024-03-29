#' Include \strong{summarytools}' \emph{css} Into Active Document
#'
#' Generate the \emph{css} needed by \strong{summarytools} in \emph{html}
#' documents.
#'
#' @param main Logical. Include \emph{summarytools.css} file. \code{TRUE} by
#'   default. This will affects only \strong{summarytools} objects, for one
#'   exception: two properties of the \code{img} tag are redefined to have
#'   \code{background-color: transparent} and \code{border: 0}.
#' @param global Logical. Include the additional \emph{summarytools-global.css}
#'   file, which affects all content in the document. Provides control over
#'   objects that were not \emph{html-rendered}; in particular, table widths
#'   and vertical alignment are modified to improve layout. \code{FALSE} by
#'   default.
#' @param bootstrap Logical. Include \emph{bootstrap.min.css}. \code{FALSE}
#'   by default.
#' @param style.tag Logical. Include the opening and closing \code{<style>}
#'   tags. \code{TRUE} by default.
#' @param \dots Character. Path to additional \emph{css} file(s) to include.
#'
#' @return The \emph{css} file(s) content silently as a character vector, and
#'   prints (using \code{cat()}) the content.
#'
#' @details Typically the function is called right after the initial setup chunk
#'   of an \emph{R markdown} document, in a chunk having options
#'   \code{echo=FALSE} and \code{results="asis"}.
#'   
#' @keywords utilities
#' @author Dominic Comtois, \email{dominic.comtois@@gmail.com}
#' @export
st_css <- function(main = TRUE,
                   global = FALSE,
                   bootstrap = FALSE, 
                   style.tag = TRUE,
                   ...) {

  output <- character()
  
  if (isTRUE(style.tag)) {
    output %+=% '<style type="text/css">\n'
  }
  
  if (isTRUE(main)) {
    output %+=% readLines(system.file(package = "summarytools",
                                      "includes/stylesheets/summarytools.css"))
  }

  if (isTRUE(global)) {
    output %+=% readLines(
      system.file(package = "summarytools",
                  "includes/stylesheets/summarytools-global.css")
    )
  }
  
  if (isTRUE(bootstrap)) {
    output %+=% readLines(system.file(package = "summarytools",
                                      "includes/stylesheets/bootstrap.min.css"))
  }
  
  dotArgs <- list(...)
  for (f in dotArgs) {
    output %+=% 
      readLines(f)
  }
  
  if (isTRUE(style.tag)) {
    output %+=% '</style>\n'
  }
  
  output <- paste(output, sep = "\n")
  cat(output)
  return(invisible(output))
}
