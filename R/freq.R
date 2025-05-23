#' Frequency Tables for Factors and Other Discrete Data
#'
#' Displays weighted or unweighted frequencies, including <NA> counts and
#' proportions.
#'
#' @param x Factor, vector, or data frame.
#' @param var Optional unquoted variable name. Provides support for piped
#'   function calls (e.g. \code{my_df \%>\% freq(my_var)}). 
#' @param round.digits Numeric. Number of significant digits to display. 
#'   Defaults to \code{2}. Can be set globally with \code{\link{st_options}}.
#' @param order Character. Ordering of rows in frequency table; \dQuote{name}
#'   (default for non-factors), \dQuote{level} (default for factors), or
#'   \dQuote{freq} (from most frequent to less frequent). To invert the order,
#'   place a minus sign before or after the word. \dQuote{-freq} will thus
#'   display the items starting from the lowest in frequency to the highest,
#'   and so forth.
#' @param style Character. Style to be used by \code{\link[pander]{pander}}. One
#'   of \dQuote{simple} (default), \dQuote{grid}, \dQuote{rmarkdown}, or
#'   \dQuote{jira}. Can be set globally with \code{\link{st_options}}.
#' @param plain.ascii Logical. \code{\link[pander]{pander}} argument; when
#'   \code{TRUE}, no markup characters will be used (useful when printing to
#'   console). Defaults to \code{TRUE} unless \code{style = 'rmarkdown'}, in
#'   which case it will be set to \code{FALSE} automatically. Can be set
#'   globally with \code{\link{st_options}}.
#' @param justify String indicating alignment of columns. By default
#'   (\dQuote{default}), \dQuote{right} is used for text tables and
#'   \dQuote{center} is used for \emph{html} tables. You can force it to one of
#'   \dQuote{left}, \dQuote{center}, or \dQuote{right}.
#' @param cumul Logical. Set to \code{FALSE} to hide cumulative proportions
#'  from results. \code{TRUE} by default. To change this value globally, see 
#'   \code{\link{st_options}}.
#' @param totals Logical. Set to \code{FALSE} to hide totals from results. 
#'   \code{TRUE} by default. To change this value globally, see 
#'   \code{\link{st_options}}.
#' @param report.nas Logical. Set to \code{FALSE} to turn off reporting of
#'   missing values. To change this default value globally, see
#'   \code{\link{st_options}}.
#' @param rows Character or numeric vector allowing subsetting of the results.
#'   The order given here will be reflected in the resulting table. If a single
#'   string is used, it will be used as a regular expression to filter row 
#'   names.
#' @param missing Text to display in NA cells. Defaults to \dQuote{}.
#' @param na.val Character. For factors and character vectors, consider this
#'   value as \code{NA}. Ignored if there are actual NA values or if it matches
#'   no value / factor level in the data. \code{NULL} by default.
#' @param display.type Logical. Should variable type be displayed? Default is
#'   \code{TRUE}.
#' @param display.labels Logical. Should variable / data frame labels be
#'   displayed? Default is \code{TRUE}. To change this default value globally,
#'   see \code{\link{st_options}}.
#' @param headings Logical. Set to \code{FALSE} to omit heading section. Can be
#'   set globally via \code{\link{st_options}}.
#' @param weights Vector of weights; must be of the same length as \code{x}.
#' @param rescale.weights Logical parameter. When set to \code{TRUE}, the total
#'   count will be the same as the unweighted \code{x}. \code{FALSE} by default.
#' @param \dots Additional arguments passed to \code{\link[pander]{pander}}.
#'
#' @return A frequency table of class \code{matrix} and \code{summarytools} with
#'   added attributes used by \emph{print} method.
#'
#' @details The default \code{plain.ascii = TRUE} option is there to make
#'   results appear cleaner in the console. To avoid rmarkdown rendering
#'   problems, this option is automatically set to \code{FALSE} whenever
#'   \code{style = "rmarkdown"} (unless \code{plain.ascii = TRUE} is made
#'   explicit in the function call).
#'
#' @note The data type represents the \code{\link[base]{class}} in most cases. 
#'
#' @examples
#' data(tobacco)
#' freq(tobacco$gender)
#' freq(tobacco$gender, totals = FALSE)
#' 
#' # Ignore NA's, don't show totals, omit headings
#' freq(tobacco$gender, report.nas = FALSE, totals = FALSE, headings = FALSE)
#' 
#' # In .Rmd documents, use the two following arguments, minimally
#' freq(tobacco$gender, style="rmarkdown", plain.ascii = FALSE)
#' 
#' # Grouped Frequencies
#' with(tobacco, stby(diseased, smoker, freq))
#' (fr_smoker_by_gender <- with(tobacco, stby(smoker, gender, freq)))
#' 
#' # Print html Source
#' print(fr_smoker_by_gender, method = "render", footnote = NA)
#' 
#' # Order by frequency (+ to -)
#' freq(tobacco$age.gr, order = "freq")
#' 
#' # Order by frequency (- to +)
#' freq(tobacco$age.gr, order = "-freq")
#' 
#' # Use the 'rows' argument to display only the 10 most common items
#' freq(tobacco$age.gr, order = "freq", rows = 1:10)
#' 
#' \dontrun{
#' # Display rendered html results in RStudio's Viewer
#' # notice 'view()' is NOT written with capital V
#' # If working outside RStudio, Web browser is used instead
#' # A temporary file is stored in temp dir
#' view(fr_smoker_by_gender)
#' 
#' # Display rendered html results in default Web browser
#' # A temporary file is stored in temp dir here too
#' print(fr_smoker_by_gender, method = "browser")
#' 
#' # Write results to text file (.txt, .md, .Rmd) or html file (.html)
#' print(fr_smoker_by_gender, method = "render", file = "fr_smoker_by_gender.md)
#' print(fr_smoker_by_gender, method = "render", file = "fr_smoker_by_gender.html)
#' }
#' 
#' @seealso \code{\link[base]{table}}
#'
#' @keywords univar classes category
#' @author Dominic Comtois, \email{dominic.comtois@@gmail.com}
#' @export
#' @importFrom stats xtabs
#' @importFrom dplyr n_distinct group_keys group_vars
#' @importFrom lubridate is.Date
#' @importFrom checkmate anyNaN
freq <- function(x,
                 var             = NULL,
                 round.digits    = st_options("round.digits"),
                 order           = "default",
                 style           = st_options("style"),
                 plain.ascii     = st_options("plain.ascii"),
                 justify         = "default",
                 cumul           = st_options("freq.cumul"),
                 totals          = st_options("freq.totals"),
                 report.nas      = st_options("freq.report.nas"),
                 rows            = numeric(),
                 missing         = "",
                 na.val          = st_options("na.val"),
                 display.type    = TRUE,
                 display.labels  = st_options("display.labels"),
                 headings        = st_options("headings"),
                 weights         = NA,
                 rescale.weights = FALSE,
                 ...) {

  # Initialize variable that will be set in check_args()
  flag_by <- logical()
  
  # Initialize variable that can be changed in lbl_to_factor
  flag_tagged_na <- FALSE
  
  if (is.call(x))
    x <- eval(x, parent.frame())

  # handle objects of class "grouped_df" (dplyr::group_by)
  if (inherits(x, "grouped_df")) {
    
    if ("var" %in% names(match.call())) {
      # var might contain a function call -- such as df %>% freq(na.omit(var1))
      if (inherits(as.list(match.call()[-1])$var, "call")) {
        var_obj <- eval(as.list(match.call()[-1])$var, envir = x)
        varname <- intersect(colnames(x), 
                             as.character(as.list(match.call()[-1])$var))
      } else {
        var_obj <- x[[as.list(match.call()[-1])$var]]
        varname <- deparse(substitute(var))
      }
    } else {
      if (ncol(x) > ncol(group_keys(x)) + 1) {
        stop("when using group_by() with freq(), only one categorical variable ",
             "may be analyzed")
      } else if (ncol(x) < ncol(group_keys(x)) + 1) {
        stop("the number of variables passed to freq() must equal the number ",
             "of grouping variables + 1")
      }
      
      var_obj <- x[[setdiff(colnames(x), group_vars(x))]]
      varname <- setdiff(colnames(x), group_vars(x))
    }

    parse_info <- parse_call(mc = match.call(), 
                             df_label = FALSE,
                             var_name = FALSE,
                             var_label = FALSE,
                             caller = "freq")
    
    outlist  <- list()
    gr_ks    <- map_groups(group_keys(x))
    gr_inds  <- attr(x, "groups")$.rows

    # Check for weights
    if (missing(weights)) {
      weights_all <- NULL
      weights_name <- NULL
    } else {
      weights_name <- deparse(substitute(weights))
      if (exists(weights_name)) {
        weights_all <- eval(weights_name)
      } else if (weights_name %in% names(x)) {
        #weights_all <- get(weights_name, envir = as.environment(x))
        weights_all <- x[[weights_name]]
      } else {
        weights_all <- force(weights)
      }
    }
    
    for (g in seq_along(gr_ks)) {
      
      if (!is.null(weights_all)) {
        weights_gr <- weights_all[gr_inds[[g]]]
      } else {
        weights_gr <- NA
      }
      
      outlist[[g]] <- freq(x               = var_obj[gr_inds[[g]]],
                           round.digits    = round.digits,
                           order           = order,
                           style           = style,
                           plain.ascii     = plain.ascii,
                           justify         = justify,
                           cumul           = cumul,
                           totals          = totals,
                           report.nas      = report.nas,
                           rows            = rows,
                           missing         = missing,
                           na.val          = na.val,
                           display.type    = display.type,
                           display.labels  = display.labels,
                           headings        = headings,
                           weights         = weights_gr,
                           rescale.weights = rescale.weights,
                           ...             = ...,
                           skip_parse      = TRUE)
      
      if (!inherits(parse_info, "try-error") && !is.null(parse_info$df_name)) {
        attr(outlist[[g]], "data_info")$Data.frame <- parse_info$df_name
      }
      
      if (!is.na(label(x))) {
        attr(outlist[[g]], "data_info")$Data.frame.label <- label(x)
      }
      
      if (exists("weights_name")) {
        attr(outlist[[g]], "data_info")$Weights <- weights_name
      }
      
      attr(outlist[[g]], "data_info")$Variable <- varname
      
      if (!is.na(label(x[[varname]]))) {
        attr(outlist[[g]], "data_info")$Variable.label <- label(x[[varname]])
      }
      
      attr(outlist[[g]], "data_info")$by_var   <- group_vars(x)
      attr(outlist[[g]], "data_info")$Group    <- gr_ks[g]
      attr(outlist[[g]], "data_info")$by_first <- g == 1
      attr(outlist[[g]], "data_info")$by_last  <- g == length(gr_ks)
      
      attr(outlist[[g]], "st_type") <- "freq"
    }
    
    names(outlist) <- gr_ks
    class(outlist) <- c("stby")
    attr(outlist, "groups") <- group_keys(x)
    return(outlist)
  }
  
  # When x is a dataframe and var is not provided, we make recursive calls
  # to freq() with each variable
  else if (is.data.frame(x) && ncol(x) > 1 && 
           !"var" %in% names(match.call())) {
    
    # Get information about x from parsing function
    parse_info <- parse_call(mc = match.call(), 
                             var_name = FALSE,
                             var_label = FALSE,
                             caller = "freq")
    
    if (!"df_name" %in% names(parse_info) || is.na(parse_info$df_name)) {
      df_name <- deparse(substitute(x))
    } else {
      df_name <- parse_info$df_name
    }
    
    out <- list()
    ignored <- character()
    for (i in seq_along(x)) {
      if (!class(x[[i]]) %in% c("character", "factor") &&
          n_distinct(x[[i]]) > st_options("freq.ignore.threshold")) {
        ignored %+=% names(x)[i] 
        next 
      }
      
      out[[length(out) + 1]] <- 
        freq(x[i],
             round.digits     = round.digits,
             order            = order,
             style            = style,
             plain.ascii      = plain.ascii,
             justify          = justify,
             cumul            = cumul,
             totals           = totals,
             report.nas       = report.nas,
             rows             = rows,
             missing          = missing,
             na.val           = na.val,
             display.type     = display.type,
             display.labels   = display.labels,
             headings         = headings,
             weights          = weights,
             rescale.weights  = rescale.weights,
             skip_parse       = TRUE,
             ...              = ...)
      
      attr(out[[length(out)]], "data_info")$Data.frame <- df_name
      attr(out[[length(out)]], "data_info")$Variable   <- colnames(x)[i]
      if (!is.na(label(x[[i]]))) {
        attr(out[[length(out)]], "data_info")$Variable.label <- label(x[[i]])
      }

      if (length(out) == 1) {
        attr(out[[length(out)]], "format_info")$var.only <- FALSE
      } else {
        attr(out[[length(out)]], "format_info")$var.only <- TRUE
      }
      
      if (length(ignored) > 0) {
        attr(out, "ignored") <- ignored
      }
    }
    class(out) <- c("list", "summarytools")
    return(out)
  } else {
    # Simple call (no iteration needed, or call from higher-level iteration)    
    if ("var" %in% names(match.call())) {
      dfname <- as.character(substitute(x))
      if (inherits(as.list(match.call()[-1])$var, "name")) {
        x <- x[[as.list(match.call()[-1])$var]]
        varname <- deparse(substitute(var))
      } else if (inherits(as.list(match.call()[-1])$var, "call")) {
        varname <- tail(all.names(as.list(match.call()[-1])$var), 1)
        x <- x[[varname]]
      }
    }
    
    # if x is a data.frame with 1 column, extract this column as x
    if (!is.null(ncol(x)) && ncol(x) == 1) {
      varname <- colnames(x)
      x <- x[[1]]
    }
    
    # Validate arguments -------------------------------------------------------
    errmsg <- character()  # problems with arguments will be stored in here
    
    if (!is.atomic(x)) {
      x <- try(as.vector(x), silent = TRUE)
      if (inherits(x, "try-error") || (!is.atomic(x) && !is.Date(x))) {
        errmsg %+=% "argument x must be a vector or factor"
      }
    }
    
    order_sign <- "+"
    errmsg <- c(errmsg, check_args(match.call(), list(...), "freq"))
    
    if (length(errmsg) > 0) {
      stop(paste(errmsg, collapse = "\n  "))
    }
    
    # End of arguments validation ----------------------------------------------
    
    # When style = "rmarkdown", make plain.ascii FALSE unless explicit
    if (style == "rmarkdown" && isTRUE(plain.ascii) && 
        !("plain.ascii" %in% (names(match.call())))) {
      if (!isTRUE(st_options("freq.silent"))) {
        message("setting plain.ascii to FALSE")
      }
      plain.ascii <- FALSE
    }
    
    # Replace NaN's by NA's (This simplifies matters a lot)
    if (NaN %in% x)  {
      if (isFALSE(st_options("freq.silent"))) {
        message(paste(sum(is.nan(x)), "NaN value(s) converted to NA\n"))
      }
      x[is.nan(x)] <- NA
    }
    
    # Convert labelled / haven_labelled to factor
    if (inherits(x, c("labelled", "haven_labelled"))) {
      lbls <- attr(x, "labels")
      is_labelled <- TRUE
      labelled_type <- paste(ifelse(is.character(x),
                                    trs("character"),
                                    trs("numeric")),
                             "(labelled)")
      x <- lbl_to_factor(x)
      if (!is.null(na.val)) {
        ind_tmp <- grep(paste0("^", na.val, " \\[.+\\]$"), levels(x))
        if (length(ind_tmp) == 1) {
          na.val <- levels(x)[ind_tmp]
        } else {
          na.val <- NULL
          if (!isTRUE(st_options("freq.silent"))) {
            message("na.val is not recognized and will be ignored")
          }
        }
      }
    } else {
      is_labelled <- FALSE
      labelled_type <- NA
    }
    
    # Replace values == na.val by NA in factors & char vars
    if (!is.null(na.val)) {
      if (is.factor(x) || is.character(x)) {
        ind_na_val <- which(x == na.val)
        
        if (length(ind_na_val)) {
          x[ind_na_val] <- NA
          if (is.factor(x)) {
            levels(x)[which(levels(x) == na.val)] <- NA
          }
        }
      } else {
        na.val <- NULL # x not char nor factor
      }
    }
    
    # Get information about x from parsing function
    if ("skip_parse" %in% names(list(...))) {
      parse_info <- list()
    } else {
      parse_info <- parse_call(mc = match.call(), 
                               caller = "freq")
    }
    
    if (!("var_name" %in% names(parse_info)) && exists("varname")) {
      parse_info$var_name <- varname
    }
    
    if (!("df_name" %in% names(parse_info)) && exists("dfname")) {
      parse_info$df_name <- dfname
    }
    
    if (!"var_label" %in% names(parse_info) && !is.na(label(x))) {
      parse_info$var_label <- label(x)
    }
    
    # create a basic frequency table, always including NA ----------------------
    if (identical(NA, weights)) {
      freq_table <- table(x, useNA = "always")
    } else {
      # Weights are used
      weights_name <- deparse(substitute(weights))
      
      # Subset weights when called from by()/stby() to match current data subset
      if (isTRUE(flag_by)) {
        pf <- parent.frame(2)
        weights <- weights[pf$X[[pf$i]]]
      }
      
      if (sum(is.na(weights)) > 0) {
        warning("missing values on weight variable have been detected and ",
                "were treated as zeroes")
        weights[is.na(weights)] <- 0
      }
      
      if (isTRUE(rescale.weights)) {
        weights <- weights / sum(weights) * length(x)
      }
      
      freq_table <- xtabs(formula = weights ~ x, addNA = TRUE)
      if (!NA %in% names(freq_table)) {
        freq_table <- c(freq_table, "<NA>" = 0)
      }
    }
    
    # If na.val is set and has 0 freq, remove it from the table
    if (!is.null(na.val)) {
      if (na.val %in% names(freq_table) && freq_table[[na.val]] == 0) {
        freq_table <- freq_table[-which(names(freq_table) == na.val)]
      }
    }
    # Order by [-]freq if needed
    if (order == "freq") {
      nas_freq   <- tail(freq_table, 1)
      freq_table <- freq_table[-length(freq_table)]
      freq_table <- sort(freq_table, decreasing = (order_sign == "+"))
      freq_table <- append(freq_table, nas_freq)
    }
    
    # order by [-]name if needed
    if (order == "name") {
      freq_table <- freq_table[order(names(freq_table), 
                                     decreasing = (order_sign == "-"), 
                                     na.last = TRUE)]
    }
    
    # order by [-]level if needed
    if (is.factor(x) && order == "level" && order_sign == "-") {
      freq_table <- c(freq_table[rev(levels(x))], tail(freq_table, 1))
    }
    
    if (is.character(rows) && length(rows) == 1) {
      # Use string as regular expression to filter rows
      rr <- grep(rows, names(freq_table))
      if (length(rr) == 0) {
        stop("'rows' argument doesn't match any data")
      }
      
      freq_table <- c(freq_table[rr], tail(freq_table, 1))
      
    } else if (length(rows) > 0) {
      if (is.character(rows)) { 
        if (length(rows) < n_distinct(x)) {
          freq_table <- 
            c(freq_table[rows], 
              "(Other)" = sum(
                freq_table[setdiff(na.omit(names(freq_table)), rows)]
                ),
              tail(freq_table, 1))
        } else {
          freq_table <- c(freq_table[rows], tail(freq_table, 1))
        }
      } else if (is.numeric(rows)) {
        if (sign(rows[1]) == 1) {
          if (length(rows) < n_distinct(x, na.rm = TRUE)) {
            freq_table <- 
              c(freq_table[rows], 
                "(Other)" = sum(freq_table[setdiff(seq_along(freq_table[-1]), 
                                                   rows)]),
                tail(freq_table, 1))
          } else {
            freq_table <- c(freq_table[rows], tail(freq_table, 1))
          }
        } else {
          ind_other <- intersect(seq_along(freq_table[-1]), abs(rows))
          freq_table <- c(freq_table[c(rows, -length(freq_table))],
                          "(Other)" = sum(freq_table[ind_other]),
                          tail(freq_table, 1))
        }
      }
    }
    
    # Change the name of the NA item (last) to avoid potential
    # problems when echoing to console
    names(freq_table)[length(freq_table)] <- "<NA>"
    
    # calculate proportions (valid, i.e excluding NA's)
    P_valid <- prop.table(freq_table[-length(freq_table)]) * 100
    
    # Add "<NA>" item to the proportions; this assures
    # proper length when cbind'ing later on
    P_valid["<NA>"] <- NA
    
    # calculate proportions (total, i.e. including NA's)
    P_tot <- prop.table(freq_table) * 100
    
    # Calculate cumulative proportions -----------------------------------------
    
    P_valid_cum <- cumsum(P_valid)
    P_valid_cum["<NA>"] <- NA
    P_tot_cum <- cumsum(P_tot)
    
    # Combine the info to build the final frequency table ----------------------
    
    output <- cbind(freq_table, P_valid, P_valid_cum, P_tot, P_tot_cum)
    output <- rbind(output, c(colSums(output, na.rm = TRUE)[1:2], rep(100,3)))
    colnames(output) <- c(trs("freq"), trs("pct.valid.f"), trs("pct.valid.cum"), 
                          trs("pct.total"), trs("pct.total.cum"))
    rownames(output) <- c(ws_to_symbol(names(freq_table)), trs("total"))
    rownames(output)[rownames(output) == ""] <- 
      paste0("(", trs("empty.str"), ")")
    
    # Change <NA> rowname with na.val if defined and used
    if (!is.null(na.val)) {
      rownames(output)[rownames(output) == "<NA>"] <- na.val 
    }
    
    # Update the output class and attributes -----------------------------------
    
    class(output) <- c("summarytools", class(output))
    
    attr(output, "st_type") <- "freq"
    attr(output, "fn_call") <- match.call()
    attr(output, "date")    <- Sys.Date()
    
    # Determine data "type", in a non-strict way
    if (is_labelled) {
      Data.type <- labelled_type
    } else if (is.ordered(x)) {
      Data.type <- trs("factor.ordered")
    } else if (is.factor(x)) {
      Data.type <- trs("factor")
    } else if (all(c("POSIXct", "POSIXt") %in% class(x))) { 
      Data.type <- trs("datetime")
    } else if (is.Date(x)) {
      Data.type <- trs("date")
    } else if (is.logical(x)) {
      Data.type <- trs("logical")
    } else if (is.character(x)) {
      Data.type <- trs("character")
    } else if (is.integer(x)) {
      Data.type <- trs("integer")
    } else if (is.numeric(x)) {
      Data.type <- trs("numeric")
    } else {
      Data.type <- ifelse(mode(x) %in% rownames(.keywords_context),
                          trs(mode(x)), mode(x))
    }

    data_info <-
      list(
        Data.frame       = ifelse("df_name" %in% names(parse_info), 
                                  parse_info$df_name, NA),
        Data.frame.label = ifelse("df_label" %in% names(parse_info), 
                                  parse_info$df_label, NA),
        Variable         = ifelse("var_name" %in% names(parse_info), 
                                  parse_info$var_name, NA),
        Variable.label   = ifelse("var_label" %in% names(parse_info), 
                                  parse_info$var_label, NA),
        Data.type        = Data.type,
        Weights          = ifelse(
          identical(weights, NA), NA,
          ifelse(is.null(parse_info$df_name), 
                 yes = weights_name,
                 no = sub(
                   pattern = paste0(parse_info$df_name,
                                    "$"), 
                   replacement = "",
                   x = weights_name, 
                   fixed = TRUE))),
        by_var           = if ("by_group" %in% names(parse_info))
                                  parse_info$by_var else NA,
        Group            = ifelse("by_group" %in% names(parse_info),
                                  parse_info$by_group, NA),
        by_first         = ifelse("by_group" %in% names(parse_info), 
                                  parse_info$by_first, NA),
        by_last          = ifelse("by_group" %in% names(parse_info), 
                                  parse_info$by_last , NA))
    
    attr(output, "data_info") <- data_info[!is.na(data_info)]
    
    attr(output, "format_info") <- list(style          = style,
                                        round.digits   = round.digits,
                                        plain.ascii    = plain.ascii,
                                        justify        = justify,
                                        cumul          = cumul,
                                        totals         = totals,
                                        report.nas     = report.nas,
                                        missing        = missing,
                                        display.type   = display.type,
                                        display.labels = display.labels,
                                        headings       = headings,
                                        split.tables   = Inf,
                                        na.val         = na.val)

    # Keep ... arguments that could be relevant for pander of format
    user_fmt <- list()
    dotArgs <- list(...)
    for (i in seq_along(dotArgs)) {
      if (class(dotArgs[[i]]) %in% 
          c("character", "numeric", "integer", "logical") &&
          length(names(dotArgs[1])) == length(dotArgs[[i]]))
          user_fmt <- append(user_fmt, dotArgs[i])
    }
    
    if (length(user_fmt))
      attr(output, "user_fmt") <- user_fmt
    
    attr(output, "lang") <- st_options("lang")
    if (flag_tagged_na) {
      message("Tagged NA values were detected and will be reported as regular ",
              "NA; use haven::as_factor() to treat them as valid values")
    }    
    return(output)
  }
}
