import std/[math, times, unittest]

import statistical_tests

# Vars
let
  x1 = @[1, 2, 3, 4]
  x2 = @[1, 2, 3]
  xc1 = @[@[1, 2, 3], @[4, 5, 6], @[7, 8, 9]]


suite "Chi2Tests":
  
  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "chi2Test_1":
    let summary = Chi2TestSummary[float](
      numberObservations: 4,
      degreesFreedom: 3,
      expectedValues: @[2.5, 2.5, 2.5, 2.5],
      chi2Statistic: 2.0,
      pValue: 0.57240670447088.round(14),
      confidenceInterval: (0.73133485993036.round(14), 4.81353383494263.round(14))
    )
    check chi2Test(x1) == summary

  test "chi2Test_2":
    let summary = Chi2TestSummary[int](
      numberObservations: 4,
      degreesFreedom: 3,
      expectedValues: @[1, 1, 1, 1],
      chi2Statistic: 14.0,
      pValue: 0.002905152774267437.round(14),
      confidenceInterval: (0.73133485993036.round(14), 4.81353383494263.round(14))
    )
    check chi2Test(x1, @[1, 1, 1, 1]) == summary

  test "contingency_chi2Test":
    let summary = Chi2ContingencyTestSummary(
      numberObservations: 45,
      degreesFreedom: 4,
      expectedValues: @[@[1.6, 2.0 , 2.4], @[4.0 , 5.0 , 6.0], @[6.4, 8.0 , 9.6]],
      chi2Statistic: 0.46875,
      pValue: 0.9764709962058341.round(14)
    )
    check chi2ContingencyTest(xc1) == summary


