import std/[math, times, unittest]

import statistical_tests


suite "BinomialTests":
  
  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "binomialTest":
    let summary = BinomialTestSummary(
      numberSuccesses: 4,
      numberObservations: 20,
      proportion: 0.2,
      pValue: 0.10190390638834.round(14),
      confidenceInterval: (0.05733399705003.round(14), 0.43661400299667.round(14))
    )
    check binomialTest(4, 20, 0.4) == summary
