import std/[math]

import distributions

type
  BinomialTestSummary* = object
    numberSuccesses*, numberObservations*: int
    proportion*, pValue*: float
    confidenceInterval*: tuple[ciL, ciU: float]

proc binomialTest*(x, n: int, p:float, confidenceIntervalAlpha: float = 0.05): BinomialTestSummary =
  ##[
    Performs a two-tailed binomial test.
    Uses the clopper peasrson method to determine the confidence interval.

    'In statistics, the binomial test is an exact test of the statistical 
    significance of deviations from a theoretically expected distribution 
    of observations into two categories.' ~ Wikipedia
    https://en.wikipedia.org/wiki/binomial_test
  ]##
  if x > n or x < 0:
    raise newException(ValueError, "`x` must: 0 <= `x` <= n")
  let 
    xProportion = x / n
    xPValue = 2 * initBinomialDistribution(n, p).cdf(abs(x)).round(14)
    xConfidenceIntervalLower = max(0.0, initBetaDistribution(x.float, n.float - x.float + 1.0).ppf(confidenceIntervalAlpha / 2))
    xConfidenceIntervalUpper = min(1.0, initBetaDistribution(x.float + 1.0, n.float - x.float).ppf(1 - confidenceIntervalAlpha / 2))
    xConfidenceInterval = (xConfidenceIntervalLower.round(14), xConfidenceIntervalUpper.round(14))
  return BinomialTestSummary(
    numberSuccesses: x,
    numberObservations: n,
    proportion: xProportion,
    pValue: xPValue,
    confidenceInterval: xConfidenceInterval
  )
