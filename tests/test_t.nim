import math
import sequtils
import times
import unittest

import statistical_tests/t

# Vars
let
    x1 = @[1, 2, 3, 4]
    x2 = @[1, 2, 3]


suite "TTests":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "one_sample_t_test":
        let summary = OneSampleTTestSummary(number_observations: 4,
                                            degrees_freedom: 3,
                                            observed_mean: 2.5,
                                            expected_mean: 0.0,
                                            standard_error: 0.6454972243679028,
                                            t_statistic: 3.872983346207417,
                                            p_value: 0.03046629166217074.round(14))
        check one_sample_t_test(x1) == summary

    test "equal_variance_t_test":
        let summary = EqualVarianceTTestSummary(x1_number_observations: 4,
                                                x2_number_observations: 3,
                                                degrees_freedom: 5,
                                                observed_mean: 0.5,
                                                expected_mean: 0.0,
                                                standard_error: 0.9036961141150639,
                                                t_statistic: 0.5532833351724882,
                                                p_value: 0.6038968976897328.round(14))
        check equal_variance_t_test(x1, x2) == summary

    test "unequal_variance_t_test":
        let summary = UnequalVarianceTTestSummary(x1_number_observations: 4,
                                                  x2_number_observations: 3,
                                                  degrees_freedom: 4.959183673469387,
                                                  observed_mean: 0.5,
                                                  expected_mean: 0.0,
                                                  standard_error: 0.8660254037844386,
                                                  t_statistic: 0.5773502691896258,
                                                  p_value: 0.5887244480896829.round(14))
        check unequal_variance_t_test(x1, x2) == summary