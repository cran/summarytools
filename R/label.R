#' Get or Set Variable or Data Frame Labels
#'
#' Assigns a label to a vector or data frame, or returns value stored 
#' in the object's \code{label} attribute (or \code{NA} if none exists).
#' 
#' @aliases label label<-
#' @usage label(x, all = FALSE, fallback = FALSE, simplify = FALSE)
#' label(x) <- value
#' 
#' @param x An R object to extract labels from.
#' @param all Logical. When x is a data frame, setting this argument to
#'   \code{TRUE} will make the function return all variable labels. By default,
#'   its value is \code{FALSE}, so that if x is a data frame, it is the data
#'   frame's label that will be returned.
#' @param fallback a logical value indicating if labels should fallback to
#'   object name(s). Defaults to \code{FALSE}.
#' @param simplify When x is a data frame and \code{all = TRUE}, coerce results
#'   to a vector and remove \code{NA}'s. Default is \code{FALSE}.
#' @param value String to be used as label. To clear existing labels, use \code{NA}
#'   or \code{NULL}.
#' 
#' @author
#' Dominic Comtois, \email{dominic.comtois@@gmail.com},
#' @note Loosely based on Gergely Daróczi's \code{\link[rapportools]{label}} 
#'   function.
#' @export
#' @importFrom utils tail
label <- function(x, all = FALSE, fallback = FALSE, simplify = FALSE) {

  if (missing(x))
    stop("No variable / data frame provided.")

  if (is.null(x))
    stop("cannot extract label from NULL")

  if (is.atomic(x)) {
    lbl <- attr(x, which = "label", exact = TRUE)
    if (is.null(lbl)) {
      if (isTRUE(fallback)) {
        lbl <- tail(as.character(substitute(x)), 1)
      } else {
        lbl <- NA_character_
      }
    }
  } else {
    if (!is.list(x)) {
      x <- as.data.frame(x)
    }
    
    if (isTRUE(all)) {
      lbl <- lapply(x, attr, which = "label", exact = TRUE)
      lbl[which(vapply(X = lbl, FUN = is.null, FUN.VALUE = logical(1)))] <- 
        NA_character_
      
      if (isTRUE(fallback)) {
        lbl[which(is.na(lbl))] <- colnames(x)[which(is.na(lbl))]
      }
      if (isTRUE(simplify)) {
        lbl <- as.character(lbl)
      } else {
        lbl <- lbl[which(!is.na(lbl))]
      }
    } else {
      lbl <- attr(x, which = "label", exact = TRUE)
      if (is.null(lbl)) {
        if (isTRUE(fallback)) {
          lbl <- tail(as.character(substitute(x)), 1)
        } else {
          lbl <- NA_character_
        }
      }
    }
  }
  
  return(lbl)
}

#' @export
"label<-" <- function(x, value) {

  if (missing(x) || missing(value))
    stop("Both x and value arguments must be provided")

  if (is.null(value))
    value <- NA
  
  if (is.data.frame(x)) {
    if (length(value) > 1 && length(value) < ncol(x))
      stop("Number of labels does not match number of columns in x")

    if (length(value) == 1 && is.na(value)) {
      attr(x, "label") <- NULL
    } else if (length(value) == 1) {
      attr(x, "label") <- value
    } else if (length(value) == ncol(x)) {
      for (i in seq_along(value)) {
        attr(x[[i]], "label") <- value[i]
      }
    } else {
      stop(paste("provide a single string to label the data frame, or a vector",
                 "of characters having length = ncol(x)"))
    }
  } else if (is.atomic(x)) {
    if (is.na(value)) {
      attr(x, "label") <- NULL
    } else if (length(value) > 1) {
      stop("A variable label must be a character vector of length 1")
    } else {
      attr(x, "label") <- value
    }
  }
  return(x)
}

#' Clear Variable and Data Frame Label(s)
#'
#' Returns the object with all labels removed. Both the \dQuote{label} attribute
#' and \pkg{Hmisc}'s \dQuote{labelled} class are removed.
#'
#' @usage unlabel(x)
#' @param x An R object to remove labels from.
#' @seealso \code{\link{label}}
#' @author
#' Dominic Comtois, \email{dominic.comtois@@gmail.com},
#' @export
unlabel <- function(x) {
  if (is.list(x)) {
    for (i in seq_along(x)) {
      class(x[[i]]) <- setdiff(class(x[[i]]), "labelled")
    }
    for (i in seq_along(x)) {
      attr(x[[i]],"label") <- NULL
    }
  }
  else {
    class(x) <- setdiff(class(x), "labelled")
    attr(x, "label") <- NULL
  }
  return(x)
}
