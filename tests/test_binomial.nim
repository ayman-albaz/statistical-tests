import math
import sequtils
import times
import unittest

import statistical_tests/binomial


suite "BinomialTests":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "binomial_test":
        let summary = BinomialTestSummary(number_successes: 4,
                                          number_observations: 20,
                                          proportion: 0.2,
                                          p_value: 0.10190390638834.round(14),
                                          confidence_interval: (0.05733399705003.round(14), 0.43661400299667.round(14)))
        check binomial_test(4, 20, 0.4) == summary
