import std/[math, times, unittest]

import statistical_tests

# Vars
let
  x1 = @[1, 2, 3, 4]
  x2 = @[1, 2, 3]

suite "TTests":
  
  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "oneSampleTTest":
    let summary = OneSampleTTestSummary(
      numberObservations: 4,
      degreesFreedom: 3,
      observedMean: 2.5,
      expectedMean: 0.0,
      standardError: 0.6454972243679028,
      tStatistic: 3.872983346207417,
      pValue: 0.03046629166217074.round(14)
    )
    check oneSampleTTest(x1) == summary

  test "equalVarianceTTest":
    let summary = EqualVarianceTTestSummary(
      x1NumberObservations: 4,
      x2NumberObservations: 3,
      degreesFreedom: 5,
      observedMean: 0.5,
      expectedMean: 0.0,
      standardError: 0.9036961141150639,
      tStatistic: 0.5532833351724882,
      pValue: 0.6038968976897328.round(14)
    )
    check equalVarianceTTest(x1, x2) == summary

  test "unequalVarianceTTest":
    let summary = UnequalVarianceTTestSummary(
      x1NumberObservations: 4,
      x2NumberObservations: 3,
      degreesFreedom: 4.959183673469387,
      observedMean: 0.5,
      expectedMean: 0.0,
      standardError: 0.8660254037844386,
      tStatistic: 0.5773502691896258,
      pValue: 0.5887244480896829.round(14)
    )
    check unequalVarianceTTest(x1, x2) == summary