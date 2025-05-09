% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dfSummary.R
\name{dfSummary}
\alias{dfSummary}
\title{Data frame Summary}
\usage{
dfSummary(
  x,
  round.digits = 1,
  varnumbers = st_options("dfSummary.varnumbers"),
  class = st_options("dfSummary.class"),
  labels.col = st_options("dfSummary.labels.col"),
  valid.col = st_options("dfSummary.valid.col"),
  na.col = st_options("dfSummary.na.col"),
  graph.col = st_options("dfSummary.graph.col"),
  graph.magnif = st_options("dfSummary.graph.magnif"),
  style = st_options("dfSummary.style"),
  plain.ascii = st_options("plain.ascii"),
  justify = "l",
  na.val = st_options("na.val"),
  col.widths = NA,
  headings = st_options("headings"),
  display.labels = st_options("display.labels"),
  max.distinct.values = 10,
  trim.strings = FALSE,
  max.string.width = 25,
  split.cells = 40,
  split.tables = Inf,
  tmp.img.dir = st_options("tmp.img.dir"),
  keep.grp.vars = FALSE,
  silent = st_options("dfSummary.silent"),
  ...
)
}
\arguments{
\item{x}{A data frame.}

\item{round.digits}{Number of significant digits to display. Defaults to
\code{1}. Does not affect proportions, which always show \code{1} digit.}

\item{varnumbers}{Logical. Show variable numbers in the first column.
Defaults to \code{TRUE}. Can be set globally with \code{\link{st_options}},
option \dQuote{dfSummary.varnumbers}.}

\item{class}{Logical. Show data classes in \emph{Variable} column.
\code{TRUE} by default.}

\item{labels.col}{Logical. If \code{TRUE}, variable labels (as defined with
\pkg{rapportools}, \pkg{Hmisc} or \pkg{summarytools}' \code{label}
functions, among others) will be displayed. \code{TRUE} by default, but
the \emph{labels} column is only shown if a label exists for at least one
column. Can be set globally with \code{\link{st_options}}, option
\dQuote{dfSummary.labels.col}.}

\item{valid.col}{Logical. Include column indicating count and proportion of
valid (non-missing) values. \code{TRUE} by default; can be set
globally with \code{\link{st_options}}, option \dQuote{dfSummary.valid.col}.}

\item{na.col}{Logical. Include column indicating count and proportion of
missing (\code{NA}) values. \code{TRUE} by default; can be set globally
with \code{\link{st_options}}, option \dQuote{dfSummary.na.col}.}

\item{graph.col}{Logical. Display barplots/histograms column. \code{TRUE}
by default; can be set globally with \code{\link{st_options}}, 
option \dQuote{dfSummary.graph.col}.}

\item{graph.magnif}{Numeric. Magnification factor for graphs column. Useful
if the graphs show up too large (then use a value such as .75) or too small
(use a value such as \code{1.25}). Must be positive. Defaults to \code{1}.
Can be set globally with \code{\link{st_options}}, option
\dQuote{dfSummary.graph.magnif}.}

\item{style}{Character. Argument used by \code{\link[pander]{pander}}.
Defaults to \dQuote{multiline}. The only other valid option
is \dQuote{grid}. Style \dQuote{rmarkdown} will fallback to
\dQuote{multiline}.}

\item{plain.ascii}{Logical. \code{\link[pander]{pander}} argument; when
\code{TRUE}, no markup characters will be used (useful when printing to
console). Defaults to \code{TRUE}. Set to \code{FALSE} when in context of
markdown rendering. To change the default value globally, see
\code{\link{st_options}}.}

\item{justify}{String indicating alignment of columns; one of \dQuote{l}
(left) \dQuote{c} (center), or \dQuote{r} (right). Defaults to \dQuote{l}.}

\item{na.val}{Character. For factors and character vectors, consider this
value as \code{NA}. Ignored if there are actual NA values. \code{NULL}
by default.}

\item{col.widths}{Numeric or character. Vector of column widths. If numeric,
values are assumed to be numbers of pixels. Otherwise, any CSS-supported
units can be used. \code{NA} by default, meaning widths are calculated
automatically.}

\item{headings}{Logical. Set to \code{FALSE} to omit headings. To change this
default value globally, see \code{\link{st_options}}.}

\item{display.labels}{Logical. Should data frame label be displayed in the
title section?  Default is \code{TRUE}. To change this default value
globally, see \code{\link{st_options}}.}

\item{max.distinct.values}{The maximum number of values to display
frequencies for. If variable has more distinct values than this number, the
remaining frequencies will be reported as a whole, along with the number of
additional distinct values. Defaults to 10.}

\item{trim.strings}{Logical; for character variables, should leading and
trailing white space be removed? Defaults to \code{FALSE}. See
\emph{details} section.}

\item{max.string.width}{Limits the number of characters to display in the
frequency tables. Defaults to \code{25}.}

\item{split.cells}{A numeric argument passed to \code{\link[pander]{pander}}.
It is the number of characters allowed on a line before splitting the cell.
Defaults to \code{40}.}

\item{split.tables}{\pkg{pander} argument which determines the maximum width
of a table. Keeping the default value (\code{Inf}) is recommended.}

\item{tmp.img.dir}{Character. Directory used to store temporary images when
rendering dfSummary() with `method = "pander"`, `plain.ascii = TRUE` and
`style = "grid"`. See \emph{Details}.}

\item{keep.grp.vars}{Logical. When using \code{\link[dplyr]{group_by}},
keep rows corresponding to grouping variable(s) in output table.
When \code{FALSE} (default), variable numbers still reflect the
the ordering in the full data frame (in other words, some numbers will
be skipped in the variable number column).}

\item{silent}{Logical. Hide console messages. \code{FALSE} by default. To
change this value globally, see \code{\link{st_options}}.}

\item{\dots}{Additional arguments passed to \code{\link[pander]{pander}}.}
}
\value{
A data frame with additional class \code{summarytools} containing as
  many rows as there are columns in \code{x}, with attributes to inform
  \code{print} method. Columns in the output data frame are:
  \describe{
    \item{No}{Number indicating the order in which column appears in the data
     frame.}
    \item{Variable}{Name of the variable, along with its class(es).}
    \item{Label}{Label of the variable (if applicable).}
    \item{Stats / Values}{For factors, a list of their values, limited by the
      \code{max.distinct.values} parameter. For character variables, the most
       common values (in descending frequency order), also limited by
      \code{max.distinct.values}. For numerical variables, common univariate
      statistics (mean, std. deviation, min, med, max, IQR and CV).}
    \item{Freqs (\% of Valid)}{For factors and character variables, the
      frequencies and proportions of the values listed in the previous
      column. For numerical vectors, number of distinct values, or frequency
      of distinct values if their number is not greater than
      \code{max.distinct.values}.}
    \item{Text Graph}{An ASCII histogram for numerical variables, and ASCII
      barplot for factors and character variables.} 
    \item{Graph}{An html encoded graph, either barplot or histogram.}
    \item{Valid}{Number and
      proportion of valid values.}
    \item{Missing}{Number and proportion of missing (NA and NAN) values.} 
    }
}
\description{
Summary of a data frame consisting of: variable names and types, labels if
any, factor levels, frequencies and/or numerical summary statistics, 
barplots/histograms, and valid/missing observation counts and proportions.
}
\details{
The default value \code{plain.ascii = TRUE} is intended to
  facilitate interactive data exploration. When using the package for
  reporting with \emph{rmarkdown}, make sure to set this option to
  \code{FALSE}.

  When \code{trim.strings} is set to \code{TRUE}, trimming is done
  \strong{\emph{before} calculating frequencies}, be aware that those will
  be impacted accordingly.
  
  Specifying \code{tmp.img.dir} allows producing results consistent with
  pandoc styling while also showing \emph{png} graphs. Due to the fact that
  in Pandoc, column widths are determined by the length of cell contents
  \strong{even if said content is merely a link to an image}, using standard
  R temporary directory to store the images would cause columns to be
  exceedingly wide. \strong{A shorter path is needed.} On Mac OS and Linux,
  using \dQuote{/tmp} is a sensible choice, since this directory is cleaned
  up automatically on a regular basis. On Windows however, there is no such
  convenient directory, so the user has to choose a directory and cleanup the
  temporary images manually after the document has been rendered. Providing
  a relative path such as \dQuote{img}, omitting \dQuote{./}, is recommended.
  The maximum length for this parameter is set to 5 characters. It can be set
  globally with \code{\link{st_options}} (\emph{e.g.:}
  \code{st_options(tmp.img.dir = ".")}.

  It is possible to \strong{control which statistics are shown} in the 
  \emph{Stats / Values} column. For this, see the \emph{Details} and
  \emph{Examples} sections of \code{\link{st_options}}.
}
\note{
Several packages provide functions for defining \emph{variable labels},
  \pkg{summarytools} being one of them. Some packages (\emph{Hmisc} in
  particular) employ special classes for labelled objects, but
  \pkg{summarytools} doesn't use nor look for any such classes.
}
\examples{

data("tobacco")
saved_x11_option <- st_options("use.x11")
st_options(use.x11 = FALSE)
dfSummary(tobacco)

# Exclude some of the columns to reduce table width
dfSummary(tobacco, varnumbers = FALSE, valid.col = FALSE)

# Limit number of categories to be displayed for categorical data
dfSummary(tobacco, max.distinct.values = 5, style = "grid")

# Using stby()
stby(tobacco, tobacco$gender, dfSummary)

st_options(use.x11 = saved_x11_option)

\dontrun{

# Show in Viewer or browser - no capital V in view(); stview() is also
# available in case of conflicts with other packages)
view(dfSummary(iris))

# Rmarkdown-ready
dfSummary(tobacco, style = "grid", plain.ascii = FALSE,
          varnumbers = FALSE, valid.col = FALSE, tmp.img.dir = "./img")

# Using group_by()
tobacco \%>\% group_by(gender) \%>\% dfSummary()
}

}
\seealso{
\code{\link{label}}, \code{\link{print.summarytools}}
}
\author{
Dominic Comtois, \email{dominic.comtois@gmail.com}
}
\keyword{attribute}
\keyword{category}
\keyword{classes}
\keyword{univar}
