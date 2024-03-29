# smart_split ------------------------------------------------------------------
# Fn to smartly split variable names that are too long
# ref: https://tinyurl.com/y7qv48z9
#' @keywords internal
smart_split <- function(str, maxlen) {
  re <- paste0("(?=.{1,", maxlen, "}(.*))",
               "(?=.*?[^\\W._].*?[\\W._].*?\\1)",
               ".{1,", maxlen, "}(?<=_|\\b|\\Z)",
               "|.{1,", maxlen, "}")
  matchinfo <- gregexpr(pattern = re,
                        text = str, perl = TRUE)
  groups <- regmatches(x = str, m = matchinfo)[[1]]
  paste(groups, collapse = "<br/>")
}

# %+=% -------------------------------------------------------------------------
# infix to simplify append()ing
#' @keywords internal
`%+=%` <- function(x, value) {
  eval.parent(substitute(x <- append(x, value)))
}

# unquote ----------------------------------------------------------------------
# Remove quotation marks inside a string
#' @keywords internal
unquote <- function(x) {
  x <- sub("^\\'(.+)\\'$", "\\1", x)
  x <- sub('^\\"(.+)\\"$', "\\1", x)
  x
}

# conv_non_ascii ---------------------------------------------------------------
# Replace accentuated characters by their html decimal entity
#' @keywords internal
conv_non_ascii <- function(...) {
  out <- character()
  for (s in list(...)) {
    if (is.null(s)) next
    splitted <- unlist(strsplit(s, ""))
    intvalues <- utf8ToInt(enc2utf8(s))
    pos_to_modify_lat <- which(intvalues >=  161 & intvalues <=  255)
    pos_to_modify_cyr <- which(intvalues >= 1024 & intvalues <= 1279)
    pos_to_modify_no  <- which(intvalues == 8470)
    pos_to_modify <- c(pos_to_modify_lat, pos_to_modify_cyr, pos_to_modify_no)
    splitted[pos_to_modify] <- paste0("&#0",  intvalues[pos_to_modify], ";")
    out <- c(out, paste0(splitted, collapse = ""))
  }
  out
}

# ws_to_symbol -----------------------------------------------------------------
# Replace leading and trailing white space in character vectors and factor
# levels by the special character intToUtf8(183)
#' @keywords internal
ws_to_symbol <- function(x) {
  
  ws_symbol <- intToUtf8(183)
  x_is_char <- is.character(x)
  if (isTRUE(x_is_char)) {
    x <- as.factor(x)
  }
  
  xx <- levels(x)
  xx_encod <- Encoding(xx)
  
  for (enc in setdiff(Encoding(xx), "unknown")) {
    xx[xx_encod == enc] <- iconv(xx[xx_encod == enc], 
                                 from = enc, to = "UTF-8")
  }
  
  left_ws_count  <- nchar(xx) - nchar(sub("^ +", "", xx))
  right_ws_count <- nchar(xx) - nchar(sub(" +$", "", xx))
  
  # Correction to avoid doubling the length of whitespace-only strings
  right_ws_count[right_ws_count == nchar(xx)] <- 0
  
  xx <- gsub("((?:\\A|\\G) )|(?&rec)( )+(?'rec')$", ws_symbol, xx, perl = TRUE)
  
  
  levels(x) <- xx
  
  if (isTRUE(x_is_char)) {
    return(as.character(x))
  } else {
    return(x)
  }
}


# Shorcut function to get translation strings
#' @keywords internal
trs <- function(item, l = st_options("lang")) {
  l <- force(l)
  if (l != "custom") {
    val <- .translations[l,item]
  } else {
    val <- .st_env$custom_lang["custom", item]
  }
  ifelse(is.na(val), "", val)
}


# Count "empty" elements (NA's / vectors of size 0)
#' @keywords internal
count_empty <- function(x, count.nas = TRUE) {
  n <- 0
  for (item in x) {
    if (length(item) == 0) {
      n <- n + 1
    } else if (isTRUE(count.nas)) {
      n <- n + sum(is.na(item))
    }
  }
  n
}

# Clone of htmltools:::paste8
#' @keywords internal
paste8 <- function(..., sep = " ", collapse = NULL) {
  args <- c(
    lapply(list(...), enc2utf8), 
    list(
      sep = if (is.null(sep)) sep else enc2utf8(sep), 
      collapse = if (is.null(collapse)) collapse else enc2utf8(collapse)
    )
  )
  do.call(paste, args)
}

# Map columns / values of dplyr's group_by objects based on group_keys
#' @keywords internal
map_groups <- function(gk) {
  grs <- c()
  for (i in seq_len(nrow(gk))) {
    gr <- paste(colnames(gk), as.character(unlist(gk[i,])), 
                sep = " = ", collapse = ", ")
    grs <- c(grs, gr)
  }
  grs
}

pad <- function(string, width) {
  paste0(strrep(" ", max(0, width - nchar(string))), string)
}

pctvalid <- function(x, round.digits = 1) {
  round(sum(!is.na(x)) / length(x) * 100, round.digits)
}
