\name{parms2plot}
\alias{parms2plot}

\title{ Matches groups of parameters to plot in MCMC diagnostics plots.}

\description{
  Utility function that finds the parameter names to plot in the \code{mcmcplot} function.  Intended for internal use only.
}

\usage{
parms2plot(parnames, parms, regex, random, leaf.marker = "[\\\\[_]", do.unlist = TRUE)
}

\arguments{
  \item{parnames}{ parameter names from an MCMC run }
  \item{parms}{ partial parameter names that will be used to determine which subset of \code{parnames} will be plotted.}
  \item{regex}{ a vector of character strings containing regular expressions to match parameter names in the \code{mcmc} object.}
  \item{random}{ an integer or \code{NULL}.  If an integer is specified, the function will select only \code{random} number of plots from each parameter group for plotting.  If \code{NULL}, all parameter names from groups specified in \code{params} will be plotted.}
  \item{leaf.marker}{ a regular expression with a character class that marks the beginning of the ``leaf'' portion of a parameter name.  The default character class includes \code{[} and \code{_}}
  \item{do.unlist}{ a logical indicating whether the function should return the vector of parameter names or a list of parameter names according to parameter "groupings" (so parameters can be accessed according to their "stems").  This option was added in order to improve the functionality of \code{mcmcplot} function.}
}

\details{
  No details.
}

\value{
  A character vector with parameter names from \code{parnames} that match the partial parameter names in \code{params}.
}

\references{
  None.
}

\author{ S. McKay Curtis with contributions from Ilya Goldin }

\note{
  None.
}

\seealso{
  \code{\link{mcmcplot}}, \code{\link{caterplot}}
}

\examples{
prm <- c(paste("gamma[", 1:30, "]", sep=""),paste("alpha[", 1:20, "]", sep=""))

parms2plot(prm, NULL, NULL, NULL)      # returns all
parms2plot(prm, NULL, NULL, 5)         # returns 5 randomly from each group
parms2plot(prm, NULL, NULL, c(5, 10))  # 5 from gamma, 10 from alpha
parms2plot(prm, NULL, NULL, c(10, NA)) # 10 from gamma, all from alpha
parms2plot(prm, "alpha", NULL, NULL)   # all alphas
parms2plot(prm, "gamma", NULL, NULL)   # all gamma
parms2plot(prm, NULL, "alpha\\\\[1[[:digit:]]\\\\]$", NULL)   # alpha[10]-alpha[19]
parms2plot(prm, "gamma", "alpha\\\\[1[[:digit:]]\\\\]$", NULL)  # all gamma and alpha[10]-alpha[19]
}

\keyword{utilities}
