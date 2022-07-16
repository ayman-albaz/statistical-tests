import std/[math, sequtils]

import distributions

import seqmathutils
import mathutils


proc calculateChi2[T: SomeNumber, S: SomeNumber](observedValues: seq[T], expectedValues: seq[S]): float = 
  var chi2: float = 0
  for i in 0..<observedValues.len:
    chi2 += mathutils.pow2(observedValues[i].float - expectedValues[i].float) / expectedValues[i].float
  return chi2

proc calculateChi2ContingencyTable[T: SomeNumber](observedValues: seq[seq[T]]): seq[seq[float]] = 
  var 
    total: T = sum(observedValues)
    totalRows: seq[T] = sum(observedValues, axis=0)
    totalCols: seq[T] = sum(observedValues, axis=1)
  return divide(dot(totalRows, totalCols), total)
  
type
  Chi2TestSummary*[S] = object
    numberObservations*, degreesFreedom*: int
    chi2Statistic*, pValue*: float
    expectedValues*: seq[S]
    confidenceInterval*: tuple[ciL, ciU: float]

proc chi2Test*[T: SomeNumber, S: SomeNumber](observedValues: seq[T], expectedValues: seq[S], confidenceIntervalAlpha: float = 0.05): Chi2TestSummary[S] =
  ##[
    Performs a two-tailed chi2 test.

    'Pearson's chi-squared test is used to determine whether there is a statistically significant 
    difference between the expected frequencies and the observed frequencies in one or more 
    categories of a contingency table.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Chi-squared_test

    Use chi2 test when number of observations >= 5, else use fisher's test
  ]##
  let 
    xNumberObservations = observedValues.len
    xDegreesFreedom = xNumberObservations - 1
    xChi2Statistic = calculateChi2(observedValues, expectedValues)
    xConfidenceIntervalLower = sqrt(seqmathutils.variance(observedValues) * xDegreesFreedom.float / initChi2Distribution(xDegreesFreedom).ppf(1 - confidenceIntervalAlpha / 2))
    xConfidenceIntervalUpper = sqrt(seqmathutils.variance(observedValues) * xDegreesFreedom.float / initChi2Distribution(xDegreesFreedom).ppf(confidenceIntervalAlpha / 2))
    xConfidenceInterval = (xConfidenceIntervalLower.round(14), xConfidenceIntervalUpper.round(14))
    xPValue = (1.0 - initChi2Distribution(xDegreesFreedom).cdf(abs(xChi2Statistic))).round(14)
    
  return Chi2TestSummary[S](
    numberObservations: xNumberObservations,
    degreesFreedom: xDegreesFreedom,
    expectedValues: expectedValues,
    chi2Statistic: xChi2Statistic,
    pValue: xPValue,
    confidenceInterval: xConfidenceInterval
  )

proc chi2Test*(observedValues: seq[SomeNumber], confidenceIntervalAlpha: float = 0.05): Chi2TestSummary[float] =
  #[
    Performs a two-tailed chi2 test.
    This version of the chi2 test, uses the mean of `observedValues` as the expected values array.

    'Pearson's chi-squared test is used to determine whether there is a statistically significant 
    difference between the expected frequencies and the observed frequencies in one or more 
    categories of a contingency table.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Chi-squared_test

    Use chi2 test when number of observations >= 5, else use fisher's test
  ]#
  let 
    xExpectedValue = seqmathutils.mean(observedValues)
    xExpectedValues = repeat(xExpectedValue, observedValues.len)
  return chi2Test(observedValues, xExpectedValues, confidenceIntervalAlpha)

type
  Chi2ContingencyTestSummary* = object
    numberObservations*, degreesFreedom*: int
    chi2Statistic*, pValue*: float
    expectedValues*: seq[seq[float]]
    confidenceInterval*: tuple[ciL, ciU: float]

proc chi2ContingencyTest*(observedValues: seq[seq[SomeNumber]]): Chi2ContingencyTestSummary =
  #[
    Performs a two-tailed chi2 test using a contingency table.
    This version of the test does not provide a confidence interval.

    Each inner seq should represent a different condition, and each value within a seq should represent an outcome type.
    E.g. This is equal to seq(seq(3, 4), seq(5, 6))
          Nothing   Recovered
      Drug     33      44
      No Drug  55      66

    'Pearson's chi-squared test is used to determine whether there is a statistically significant 
    difference between the expected frequencies and the observed frequencies in one or more 
    categories of a contingency table.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Chi-squared_test

    Each cell should be >= 5
  ]#
  let 
    xNumberRows = observedValues.len
    xNumberCols = observedValues[0].len
    xNumberObservations = sum(observedValues).int
    xDegreesFreedom = (xNumberRows - 1) * (xNumberRows - 1)
    xExpectedValues = calculateChi2ContingencyTable(observedValues)
    xChi2Statistic = calculateChi2(flatten(observedValues), flatten(xExpectedValues))
    xPValue = (1.0 - initChi2Distribution(xDegreesFreedom).cdf(abs(xChi2Statistic))).round(14)
    
  return Chi2ContingencyTestSummary(
    numberObservations: xNumberObservations,
    degreesFreedom: xDegreesFreedom,
    expectedValues: xExpectedValues,
    chi2Statistic: xChi2Statistic,
    pValue: xPValue
  )

