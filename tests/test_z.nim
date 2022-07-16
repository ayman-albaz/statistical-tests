import std/[math, times, unittest]

import statistical_tests

# Vars
let
  x1 = @[1, 2, 3, 4]
  x2 = @[1, 2, 3]


suite "ZTests":
  
  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "oneSampleZTest":
    let summary = OneSampleZTestSummary(
      numberObservations: 4,
      observedMean: 2.5,
      expectedMean: 0.0,
      standardError: 0.6454972243679028,
      zStatistic: 3.872983346207417,
      pValue: 0.000107511176729469.round(14),
      confidenceInterval: (1.23484868811834.round(14), 3.76515131188166.round(14))
    )
    check oneSampleZTest(x1) == summary

  test "equalVarianceZTest":
    let summary = EqualVarianceZTestSummary(
      x1NumberObservations: 4,
      x2NumberObservations: 3,
      observedMean: 0.5,
      expectedMean: 0.0,
      standardError: 0.9036961141150638,
      zStatistic: 0.5532833351724882,
      pValue: 0.580069410520029.round(14),
      confidenceInterval: (-1.271211836634324.round(14), 2.271211836634324.round(14))
    )
    check equalVarianceZTest(x1, x2) == summary

  test "unequalVarianceZTest":
    let summary = UnequalVarianceZTestSummary(
      x1NumberObservations: 4,
      x2NumberObservations: 3,
      observedMean: 0.5,
      expectedMean: 0.0,
      standardError: 0.8660254037844386,
      zStatistic: 0.5773502691896258,
      pValue: 0.563702861650773.round(14),
      confidenceInterval: (-1.197378601114258.round(14), 2.197378601114258.round(14))
    )
    check unequalVarianceZTest(x1, x2) == summary
