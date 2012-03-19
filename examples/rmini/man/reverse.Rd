\name{reverse}
\alias{reverse}
\title{Reverse elements}
\usage{
reverse(x)
}
\arguments{
  \item{x}{a numeric vector}
}
\value{
  a numeric vector (reversed \code{x})
}
\description{
  This function takes a numeric vector and returns a
  reversed version of this vector. The internal computation
  is via C.
}
\examples{
reverse(c(1, 9.3, 8.2, 4.33))
reverse(1:10)
}
\author{
  Yihui Xie
}
