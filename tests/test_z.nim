import math
import sequtils
import times
import unittest

import statistical_tests/z

# Vars
let
    x1 = @[1, 2, 3, 4]
    x2 = @[1, 2, 3]


suite "ZTests":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "one_sample_z_test":
        let summary = OneSampleZTestSummary(number_observations: 4,
                                            observed_mean: 2.5,
                                            expected_mean: 0.0,
                                            standard_error: 0.6454972243679028,
                                            z_statistic: 3.872983346207417,
                                            p_value: 0.000107511176729469.round(14),
                                            confidence_interval: (1.23484868811834.round(14), 3.76515131188166.round(14)))
        check one_sample_z_test(x1) == summary

    test "equal_variance_z_test":
        let summary = EqualVarianceZTestSummary(x1_number_observations: 4,
                                                x2_number_observations: 3,
                                                observed_mean: 0.5,
                                                expected_mean: 0.0,
                                                standard_error: 0.9036961141150638,
                                                z_statistic: 0.5532833351724882,
                                                p_value: 0.580069410520029.round(14),
                                                confidence_interval: (-1.271211836634324.round(14), 2.271211836634324.round(14)))
        check equal_variance_z_test(x1, x2) == summary

    test "unequal_variance_z_test":
        let summary = UnequalVarianceZTestSummary(x1_number_observations: 4,
                                                  x2_number_observations: 3,
                                                  observed_mean: 0.5,
                                                  expected_mean: 0.0,
                                                  standard_error: 0.8660254037844386,
                                                  z_statistic: 0.5773502691896258,
                                                  p_value: 0.563702861650773.round(14),
                                                  confidence_interval: (-1.197378601114258.round(14), 2.197378601114258.round(14)))
        check unequal_variance_z_test(x1, x2) == summary
