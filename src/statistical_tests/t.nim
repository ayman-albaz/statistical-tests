import std/[math]

import distributions

import seqmathutils
import mathutils


type
  OneSampleTTestSummary* = object
    numberObservations*, degreesFreedom*: int
    observedMean*, expectedMean*, standardError*, tStatistic*, pValue*: float


proc oneSampleTTest*(x: seq[SomeNumber], expectedMean: float = 0.0): OneSampleTTestSummary =
  ##[
    Performs a one sample t test.
    Currently, t tests in this module do not output a confidence interval.

    'The t-test can be used, for example, to determine if the means of two sets of data 
    are significantly different from each other. 

    The assumptions underlying a t-test in the simplest form above are that:
    - X follows a normal distribution with mean μ and variance σ2/n
    - s2(n − 1)/σ2 follows a χ2 distribution with n − 1 degrees of freedom. 
    This assumption is met when the observations used for estimating s2 
    come from a normal distribution (and i.i.d for each group).
    - Z and s are independent.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Student%27s_t-test#Assumptions
  ]##
  let 
    xNumberObservations = x.len
    xDegreesFreedom = xNumberObservations - 1
    xObservedMean = seqmathutils.mean(x)
    xStandardError = standardDeviation(x) / xNumberObservations.float.sqrt()
    xTStatistic = (xObservedMean - expectedMean) / xStandardError
    xPValue = (2 * (1.0 - initTDistribution(xDegreesFreedom).cdf(abs(xTStatistic)))).round(14)
    
  return OneSampleTTestSummary(
    numberObservations: xNumberObservations,
    degreesFreedom: xDegreesFreedom,
    observedMean: xObservedMean,
    expectedMean: expectedMean,
    standardError: xStandardError,
    tStatistic: xTStatistic,
    pValue: xPValue
  )

type
  EqualVarianceTTestSummary* = object
    x1NumberObservations*, x2NumberObservations*, degreesFreedom*: int
    observedMean*, expectedMean*, standardError*, tStatistic*, pValue*: float


proc equalVarianceTTest*(x1, x2: seq[SomeNumber], expectedMean: float = 0.0): EqualVarianceTTestSummary =
  ##[
    Performs an equal variance t test.
    Currently, t tests in this module do not output a confidence interval.

    'The t-test can be used, for example, to determine if the means of two sets of data 
    are significantly different from each other. 

    In the t-test comparing the means of two independent samples, the following assumptions should be met:
    - The means of the two populations being compared should follow normal distributions. 
    Under weak assumptions, this follows in large samples from the central limit theorem, 
    even when the distribution of observations in each group is non-normal.
    - If using Student's original definition of the t-test, 
    the two populations being compared should have the same variance 
    (testable using F-test, Levene's test, Bartlett's test, or the Brown–Forsythe test; 
    or assessable graphically using a Q–Q plot). If the sample sizes in the two groups 
    being compared are equal, Student's original t-test is highly robust to the presence 
    of unequal variances. Welch's t-test is insensitive to equality of the variances regardless 
    of whether the sample sizes are similar.
    - The data used to carry out the test should either be sampled independently 
    from the two populations being compared or be fully paired. This is in general not 
    testable from the data, but if the data are known to be dependent (e.g. paired by test design), 
    a dependent test has to be applied. For partially paired data, the classical independent t-tests 
    may give invalid results as the test statistic might not follow a t distribution, while the dependent 
    t-test is sub-optimal as it discards the unpaired data.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Student%27s_t-test#Assumptions
  ]##
  let 
    x1NumberObservations = x1.len
    x2NumberObservations = x2.len
    xDegreesFreedom = x1NumberObservations + x2NumberObservations - 2
    xObservedMean = seqmathutils.mean(x1) - seqmathutils.mean(x2)
    xStandardError = sqrt(pooledVariance(x1, x2) * (1 / x1NumberObservations + 1 / x2NumberObservations))
    xTStatistic = (xObservedMean - expectedMean) / xStandardError
    xPValue = (2 * (1.0 - initTDistribution(xDegreesFreedom).cdf(abs(xTStatistic)))).round(14)
    
  return EqualVarianceTTestSummary(
    x1NumberObservations: x1NumberObservations,
    x2NumberObservations: x2NumberObservations,
    degreesFreedom: xDegreesFreedom,
    observedMean: xObservedMean,
    expectedMean: expectedMean,
    standardError: xStandardError,
    tStatistic: xTStatistic,
    pValue: xPValue
  )

type
  UnequalVarianceTTestSummary* = object
    x1NumberObservations*, x2NumberObservations*: int
    degreesFreedom*, observedMean*, expectedMean*, standardError*, tStatistic*, pValue*: float

proc unequalVarianceTTest*(x1, x2: seq[SomeNumber], expectedMean: float = 0.0): UnequalVarianceTTestSummary =
  ##[
    Performs an unequal variance t test.
    Currently, t tests in this module do not output a confidence interval.

    'The t-test can be used, for example, to determine if the means of two sets of data 
    are significantly different from each other. 

    In the t-test comparing the means of two independent samples, the following assumptions should be met:
    - The means of the two populations being compared should follow normal distributions. 
    Under weak assumptions, this follows in large samples from the central limit theorem, 
    even when the distribution of observations in each group is non-normal.
    - If using Student's original definition of the t-test, 
    the two populations being compared should have the same variance 
    (testable using F-test, Levene's test, Bartlett's test, or the Brown–Forsythe test; 
    or assessable graphically using a Q–Q plot). If the sample sizes in the two groups 
    being compared are equal, Student's original t-test is highly robust to the presence 
    of unequal variances. Welch's t-test is insensitive to equality of the variances regardless 
    of whether the sample sizes are similar.
    - The data used to carry out the test should either be sampled independently 
    from the two populations being compared or be fully paired. This is in general not 
    testable from the data, but if the data are known to be dependent (e.g. paired by test design), 
    a dependent test has to be applied. For partially paired data, the classical independent t-tests 
    may give invalid results as the test statistic might not follow a t distribution, while the dependent 
    t-test is sub-optimal as it discards the unpaired data.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Student%27s_t-test#Assumptions
  ]##
  let 
    x1NumberObservations = x1.len
    x2NumberObservations = x2.len
    x1_var = seqmathutils.variance(x1)
    x2_var = seqmathutils.variance(x2)
    xDegreesFreedom = mathutils.pow2(x1_var / x1NumberObservations.float + x2_var / x2NumberObservations.float) / (mathutils.pow2(x1_var / x1NumberObservations.float) / (x1NumberObservations.float - 1) + mathutils.pow2(x2_var / x2NumberObservations.float) / (x2NumberObservations.float - 1))
    xObservedMean = seqmathutils.mean(x1) - seqmathutils.mean(x2)
    xStandardError = sqrt(x1_var / x1NumberObservations.float + x2_var / x2NumberObservations.float)
    xTStatistic = (xObservedMean - expectedMean) / xStandardError
    xPValue = (2 * (1.0 - initTDistribution(xDegreesFreedom.round().int).cdf(abs(xTStatistic)))).round(14)
    
  return UnequalVarianceTTestSummary(
    x1NumberObservations: x1NumberObservations,
    x2NumberObservations: x2NumberObservations,
    degreesFreedom: xDegreesFreedom,
    observedMean: xObservedMean,
    expectedMean: expectedMean,
    standardError: xStandardError,
    tStatistic: xTStatistic,
    pValue: xPValue
  )
