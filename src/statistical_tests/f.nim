import std/[math]

import distributions

import seqmathutils


type
  FTestSummary* = object
    x1NumberObservations*, x2NumberObservations*, x1DegreesFreedom*, x2DegreesFreedom*: int
    fStatistic*, pValue*: float
    confidenceInterval*: tuple[ciL, ciU: float]


proc fTest*(x1, x2: seq[SomeNumber], confidenceIntervalAlpha: float = 0.05): FTestSummary =
  ##[
    Performs a two-tailed F test.

    'Common examples of the use of F-tests include the study of the following cases:
     - The hypothesis that the means of a given set of normally distributed populations, all having the same standard deviation, are equal. This is perhaps the best-known F-test, and plays an important role in the analysis of variance (ANOVA).
     - The hypothesis that a proposed regression model fits the data well. See Lack-of-fit sum of squares.
     - The hypothesis that a data set in a regression analysis follows the simpler of two proposed linear models that are nested within each other.

    The F-test is sensitive to non-normality. In the analysis of variance (ANOVA), 
    alternative tests include Levene's test, Bartlett's test, and the Brown–Forsythe test. 
    However, when any of these tests are conducted to test the underlying 
    assumption of homoscedasticity (i.e. homogeneity of variance), as a preliminary step 
    to testing for mean effects, there is an increase in the experiment-wise Type I error rate.' ~ Wikipedia
    https://en.wikipedia.org/wiki/F-test
  ]##
  let 
    x1NumberObservations = x1.len
    x2NumberObservations = x2.len
    x1DegreesFreedom = x1NumberObservations - 1
    x2DegreesFreedom = x2NumberObservations - 1
    x1Variance = seqmathutils.variance(x1) 
    x2Variance = seqmathutils.variance(x2)
    xFStatistic = x1Variance / x2Variance
    xPValue = (2 * (1.0 - initFDistribution(x1DegreesFreedom, x2DegreesFreedom).cdf(abs(xFStatistic)))).round(14)
    xConfidenceIntervalUpper = xFStatistic * initFDistribution(x2DegreesFreedom, x1DegreesFreedom).ppf(1 - confidenceIntervalAlpha / 2)
    xConfidenceIntervalLower = xFStatistic / initFDistribution(x1DegreesFreedom, x2DegreesFreedom).ppf(1 - confidenceIntervalAlpha / 2)
    xConfidenceInterval = (xConfidenceIntervalLower.round(14), xConfidenceIntervalUpper.round(14))

  return FTestSummary(
    x1NumberObservations: x1NumberObservations,
    x2NumberObservations: x2NumberObservations,
    x1DegreesFreedom: x1DegreesFreedom,
    x2DegreesFreedom: x2DegreesFreedom,
    fStatistic: xFStatistic,
    pValue: xPValue,
    confidenceInterval: xConfidenceInterval
  )
