% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/what.is.R
\name{what.is}
\alias{what.is}
\title{Obtain Extended Properties of Objects}
\usage{
what.is(x, ...)
}
\arguments{
\item{x}{Any object.}

\item{\dots}{Included for backward-compatibility only. Has no real use.}
}
\value{
A list with following elements: 
\describe{
  \item{properties}{A data frame with the class(es), type, mode and storage
    mode of the object as well as the dim, length and object.size.}
  \item{attributes.lengths}{A named character vector giving all attributes
    (\emph{c.f.} \dQuote{names}, \dQuote{row.names}, \dQuote{class},
    \dQuote{dim}, and so forth) along with their length.}
  \item{extensive.is}{A character vector of all the 
    \emph{identifier functions.} (starting with \dQuote{is.}) that yield 
    \code{TRUE} when used with \code{x} as argument.}
  \item{function.type}{When x is a function, results of 
  \code{\link[pryr]{ftype}} are added.}
}
}
\description{
Combination of most common \dQuote{macro-level} functions that describe an 
object.
}
\details{
An alternative to calling in turn \code{\link{class}}, \code{\link{typeof}},
\code{\link{dim}}, and so on. A call to this function will readily give all
this information at once.
}
\examples{
what.is(1)
what.is(NaN)
what.is(iris3)
what.is(print)
what.is(what.is)

}
\seealso{
\code{\link{class}}, \code{\link{typeof}}, \code{\link{mode}},
\code{\link{storage.mode}}, \code{\link{dim}}, \code{\link{length}},
\code{\link{is.object}}, \code{\link[pryr]{otype}},
\code{\link{object.size}}, \code{\link[pryr]{ftype}}
}
\author{
Dominic Comtois, \email{dominic.comtois@gmail.com}
}
\keyword{attribute}
\keyword{classes}
\keyword{utilities}
