import math
import sequtils
import times
import unittest

import statistical_tests/chi2

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

    test "chi2_test_1":
        let summary = Chi2TestSummary[float](number_observations: 4,
                                      degrees_freedom: 3,
                                      expected_values: @[2.5, 2.5, 2.5, 2.5],
                                      chi2_statistic: 2.0,
                                      p_value: 0.57240670447088.round(14),
                                      confidence_interval: (0.73133485993036.round(14), 4.81353383494263.round(14)))
        check chi2_test(x1) == summary

    test "chi2_test_2":
        let summary = Chi2TestSummary[int](number_observations: 4,
                                           degrees_freedom: 3,
                                           expected_values: @[1, 1, 1, 1],
                                           chi2_statistic: 14.0,
                                           p_value: 0.002905152774267437.round(14),
                                           confidence_interval: (0.73133485993036.round(14), 4.81353383494263.round(14)))
        check chi2_test(x1, @[1, 1, 1, 1]) == summary

    test "contingency_chi2_test":
        let summary = Chi2ContingencyTestSummary(number_observations: 45,
                                                 degrees_freedom: 4,
                                                 expected_values: @[@[1.6, 2.0 , 2.4], @[4.0 , 5.0 , 6.0], @[6.4, 8.0 , 9.6]],
                                                 chi2_statistic: 0.46875,
                                                 p_value: 0.9764709962058341.round(14))
        check chi2_contingency_test(xc1) == summary


