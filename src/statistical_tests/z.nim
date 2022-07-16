import std/[math]
import distributions

import seqmathutils


type
  OneSampleZTestSummary* = object
    numberObservations*: int
    observedMean*, expectedMean*, standardError*, zStatistic*, pValue*: float
    confidenceInterval*: tuple[ciL, ciU: float]

proc oneSampleZTest*(x: seq[SomeNumber], expectedMean: float = 0.0, confidenceIntervalAlpha: float = 0.05): OneSampleZTestSummary =
  ##[
    'Z-tests test the mean of a distribution.

    For the Z-test to be applicable, certain conditions must be met.
    - Nuisance parameters should be known, or estimated with high accuracy 
    (an example of a nuisance parameter would be the standard deviation in a one-sample location test). 
    Z-tests focus on a single parameter, and treat all other unknown parameters as being fixed at their true values. 
    In practice, due to Slutsky's theorem, "plugging in" consistent estimates of nuisance parameters can be justified. 
    However if the sample size is not large enough for these estimates to be reasonably accurate, 
    the Z-test may not perform well.
    - The test statistic should follow a normal distribution. 
    Generally, one appeals to the central limit theorem to justify assuming that a 
    test statistic varies normally. There is a great deal of statistical research on the 
    question of when a test statistic varies approximately normally. If the variation of the 
    test statistic is strongly non-normal, a Z-test should not be used.' ~ Wikipedia
    
    - Z and s are independent.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Z-test#Conditions
  ]##
  let 
    xNumberObservations = x.len
    xObservedMean = seqmathutils.mean(x)
    xStandardError = standardDeviation(x) / xNumberObservations.float.sqrt()
    xZStatistic = (xObservedMean - expectedMean) / xStandardError
    xPValue = (2 * (1.0 - initNormalDistribution().cdf(abs(xZStatistic)))).round(14)
    xZConfidenceInterval = initNormalDistribution().ppf(1 - confidenceIntervalAlpha / 2.0)
    xConfidenceInterval = (xObservedMean - xZConfidenceInterval * xStandardError, xObservedMean + xZConfidenceInterval * xStandardError)
    
  return OneSampleZTestSummary(
    numberObservations: xNumberObservations,
    observedMean: xObservedMean,
    expectedMean: expectedMean,
    standardError: xStandardError,
    zStatistic: xZStatistic,
    pValue: xPValue,
    confidenceInterval: xConfidenceInterval
  )

type
  EqualVarianceZTestSummary* = object
    x1NumberObservations*, x2NumberObservations*: int
    observedMean*, expectedMean*, standardError*, zStatistic*, pValue*: float
    confidenceInterval*: tuple[ciL, ciU: float]

proc equalVarianceZTest*(x1, x2: seq[SomeNumber], expectedMean: float = 0.0, confidenceIntervalAlpha: float = 0.05): EqualVarianceZTestSummary =
  ##[
    'Z-tests test the mean of a distribution.

    For the Z-test to be applicable, certain conditions must be met.
    - Nuisance parameters should be known, or estimated with high accuracy 
    (an example of a nuisance parameter would be the standard deviation in a one-sample location test). 
    Z-tests focus on a single parameter, and treat all other unknown parameters as being fixed at their true values. 
    In practice, due to Slutsky's theorem, "plugging in" consistent estimates of nuisance parameters can be justified. 
    However if the sample size is not large enough for these estimates to be reasonably accurate, 
    the Z-test may not perform well.
    - The test statistic should follow a normal distribution. 
    Generally, one appeals to the central limit theorem to justify assuming that a 
    test statistic varies normally. There is a great deal of statistical research on the 
    question of when a test statistic varies approximately normally. If the variation of the 
    test statistic is strongly non-normal, a Z-test should not be used.' ~ Wikipedia
    
    - Z and s are independent.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Z-test#Conditions
  ]##
  let 
    x1NumberObservations = x1.len
    x2NumberObservations = x2.len
    xObservedMean = seqmathutils.mean(x1) - seqmathutils.mean(x2)
    xStandardDeviation = sqrt((seqmathutils.variance(x1) * (x1NumberObservations - 1).float + seqmathutils.variance(x2) * (x2NumberObservations - 1).float) / (x1NumberObservations + x2NumberObservations - 2).float)
    xStandardError = xStandardDeviation * sqrt(1 / x1NumberObservations + 1 / x2NumberObservations)
    xZStatistic = (xObservedMean - expectedMean) / xStandardError
    xPValue = (2 * (1.0 - initNormalDistribution().cdf(abs(xZStatistic)))).round(14)
    xZConfidenceInterval = initNormalDistribution().ppf(1 - confidenceIntervalAlpha / 2.0)
    xConfidenceInterval = ((xObservedMean - xZConfidenceInterval * xStandardError).round(14), (xObservedMean + xZConfidenceInterval * xStandardError).round(14))
    
  return EqualVarianceZTestSummary(
    x1NumberObservations: x1NumberObservations,
    x2NumberObservations: x2NumberObservations,
    observedMean: xObservedMean,
    expectedMean: expectedMean,
    standardError: xStandardError,
    zStatistic: xZStatistic,
    pValue: xPValue,
    confidenceInterval: xConfidenceInterval
  )

type
  UnequalVarianceZTestSummary* = object
    x1NumberObservations*, x2NumberObservations*: int
    observedMean*, expectedMean*, standardError*, zStatistic*, pValue*: float
    confidenceInterval*: tuple[ciL, ciU: float]

proc unequalVarianceZTest*(x1, x2: seq[SomeNumber], expectedMean: float = 0.0, confidenceIntervalAlpha: float = 0.05): UnequalVarianceZTestSummary =
  ##[
    'Z-tests test the mean of a distribution.

    For the Z-test to be applicable, certain conditions must be met.
    - Nuisance parameters should be known, or estimated with high accuracy 
    (an example of a nuisance parameter would be the standard deviation in a one-sample location test). 
    Z-tests focus on a single parameter, and treat all other unknown parameters as being fixed at their true values. 
    In practice, due to Slutsky's theorem, "plugging in" consistent estimates of nuisance parameters can be justified. 
    However if the sample size is not large enough for these estimates to be reasonably accurate, 
    the Z-test may not perform well.
    - The test statistic should follow a normal distribution. 
    Generally, one appeals to the central limit theorem to justify assuming that a 
    test statistic varies normally. There is a great deal of statistical research on the 
    question of when a test statistic varies approximately normally. If the variation of the 
    test statistic is strongly non-normal, a Z-test should not be used.' ~ Wikipedia
    
    - Z and s are independent.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Z-test#Conditions
  ]##
  let 
    x1NumberObservations = x1.len
    x2NumberObservations = x2.len
    xObservedMean = seqmathutils.mean(x1) - seqmathutils.mean(x2)
    xStandardError = sqrt(seqmathutils.variance(x1) / x1NumberObservations.float + seqmathutils.variance(x2) / x2NumberObservations.float)
    xZStatistic = (xObservedMean - expectedMean) / xStandardError
    xPValue = (2 * (1.0 - initNormalDistribution().cdf(abs(xZStatistic)))).round(14)
    xZConfidenceInterval = initNormalDistribution().ppf(1 - confidenceIntervalAlpha / 2.0)
    xConfidenceInterval = ((xObservedMean - xZConfidenceInterval * xStandardError).round(14), (xObservedMean + xZConfidenceInterval * xStandardError).round(14))
  
  return UnequalVarianceZTestSummary(
    x1NumberObservations: x1NumberObservations,
    x2NumberObservations: x2NumberObservations,
    observedMean: xObservedMean,
    expectedMean: expectedMean,
    standardError: xStandardError,
    zStatistic: xZStatistic,
    pValue: xPValue,
    confidenceInterval: xConfidenceInterval
  )
