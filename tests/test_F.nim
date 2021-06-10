import math
import sequtils
import times
import unittest

import statistical_tests/F

# Vars
let
    x1 = @[1, 2, 3, 4]
    x2 = @[1, 2, 3]


suite "FTests":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "F_test":
        let summary = FTestSummary(x1_number_observations: 4,
                                   x2_number_observations: 3,
                                   x1_degrees_freedom: 3,
                                   x2_degrees_freedom: 2,
                                   F_statistic: 1.6666666666666667,
                                   p_value: 0.792636778959262.round(14),
                                   confidence_interval: (0.042554464975352.round(14), 26.74017738212865.round(14)))
        check F_test(x1, x2) == summary
