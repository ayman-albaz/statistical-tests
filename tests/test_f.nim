import std/[math, times, unittest]

import statistical_tests

# Vars
let
  x1 = @[1, 2, 3, 4]
  x2 = @[1, 2, 3]

suite "FTests":
  
  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "fTest":
    let summary = FTestSummary(
      x1NumberObservations: 4,
      x2NumberObservations: 3,
      x1DegreesFreedom: 3,
      x2DegreesFreedom: 2,
      fStatistic: 1.6666666666666667,
      pValue: 0.792636778959262.round(14),
      confidenceInterval: (0.042554464975352.round(14), 26.74017738212865.round(14))
    )
    check fTest(x1, x2) == summary
