type
    Submodule* = object
        name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import distributions/normal
import math
import sequtils

import seq_math_utils
import math_utils


type
    OneSampleZTestSummary* = object
        number_observations*: int
        observed_mean*, expected_mean*, standard_error*, z_statistic*, p_value*: float
        confidence_interval*: tuple[ci_l, ci_u: float]


proc one_sample_z_test*(x: seq[SomeNumber], expected_mean: float = 0.0, confidence_interval_alpha: float = 0.05): OneSampleZTestSummary =
    #[
        'Z-tests test the mean of a distribution.

        For the Z-test to be applicable, certain conditions must be met.
        - Nuisance parameters should be known, or estimated with high accuracy 
        (an example of a nuisance parameter would be the standard deviation in a one-sample location test). 
        Z-tests focus on a single parameter, and treat all other unknown parameters as being fixed at their true values. 
        In practice, due to Slutsky's theorem, "plugging in" consistent estimates of nuisance parameters can be justified. 
        However if the sample size is not large enough for these estimates to be reasonably accurate, 
        the Z-test may not perform well.
        - The test statistic should follow a normal distribution. 
        Generally, one appeals to the central limit theorem to justify assuming that a 
        test statistic varies normally. There is a great deal of statistical research on the 
        question of when a test statistic varies approximately normally. If the variation of the 
        test statistic is strongly non-normal, a Z-test should not be used.' ~ Wikipedia
        
        - Z and s are independent.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Z-test#Conditions
    ]#
    let 
        x_number_observations = x.len
        x_observed_mean = mean(x)
        x_standard_error = standard_deviation(x) / x_number_observations.float.sqrt()
        x_z_statistic = (x_observed_mean - expected_mean) / x_standard_error
        x_p_value = (2 * (1.0 - initNormalDistribution().cdf(abs(x_z_statistic)))).round(14)
        x_z_confidence_interval = initNormalDistribution().ppf(1 - confidence_interval_alpha / 2.0)
        x_confidence_interval = (x_observed_mean - x_z_confidence_interval * x_standard_error, x_observed_mean + x_z_confidence_interval * x_standard_error)
        
    return OneSampleZTestSummary(number_observations: x_number_observations,
                                 observed_mean: x_observed_mean,
                                 expected_mean: expected_mean,
                                 standard_error: x_standard_error,
                                 z_statistic: x_z_statistic,
                                 p_value: x_p_value,
                                 confidence_interval: x_confidence_interval)


type
    EqualVarianceZTestSummary* = object
        x1_number_observations*, x2_number_observations*: int
        observed_mean*, expected_mean*, standard_error*, z_statistic*, p_value*: float
        confidence_interval*: tuple[ci_l, ci_u: float]


proc equal_variance_z_test*(x1, x2: seq[SomeNumber], expected_mean: float = 0.0, confidence_interval_alpha: float = 0.05): EqualVarianceZTestSummary =
    #[
        'Z-tests test the mean of a distribution.

        For the Z-test to be applicable, certain conditions must be met.
        - Nuisance parameters should be known, or estimated with high accuracy 
        (an example of a nuisance parameter would be the standard deviation in a one-sample location test). 
        Z-tests focus on a single parameter, and treat all other unknown parameters as being fixed at their true values. 
        In practice, due to Slutsky's theorem, "plugging in" consistent estimates of nuisance parameters can be justified. 
        However if the sample size is not large enough for these estimates to be reasonably accurate, 
        the Z-test may not perform well.
        - The test statistic should follow a normal distribution. 
        Generally, one appeals to the central limit theorem to justify assuming that a 
        test statistic varies normally. There is a great deal of statistical research on the 
        question of when a test statistic varies approximately normally. If the variation of the 
        test statistic is strongly non-normal, a Z-test should not be used.' ~ Wikipedia
        
        - Z and s are independent.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Z-test#Conditions
    ]#
    let 
        x1_number_observations = x1.len
        x2_number_observations = x2.len
        x_observed_mean = mean(x1) - mean(x2)
        x_standard_deviation = sqrt((variance(x1) * (x1_number_observations - 1).float + variance(x2) * (x2_number_observations - 1).float) / (x1_number_observations + x2_number_observations - 2).float)
        x_standard_error = x_standard_deviation * sqrt(1 / x1_number_observations + 1 / x2_number_observations)
        x_z_statistic = (x_observed_mean - expected_mean) / x_standard_error
        x_p_value = (2 * (1.0 - initNormalDistribution().cdf(abs(x_z_statistic)))).round(14)
        x_z_confidence_interval = initNormalDistribution().ppf(1 - confidence_interval_alpha / 2.0)
        x_confidence_interval = ((x_observed_mean - x_z_confidence_interval * x_standard_error).round(14), (x_observed_mean + x_z_confidence_interval * x_standard_error).round(14))
        
    return EqualVarianceZTestSummary(x1_number_observations: x1_number_observations,
                                     x2_number_observations: x2_number_observations,
                                     observed_mean: x_observed_mean,
                                     expected_mean: expected_mean,
                                     standard_error: x_standard_error,
                                     z_statistic: x_z_statistic,
                                     p_value: x_p_value,
                                     confidence_interval: x_confidence_interval)


type
    UnequalVarianceZTestSummary* = object
        x1_number_observations*, x2_number_observations*: int
        observed_mean*, expected_mean*, standard_error*, z_statistic*, p_value*: float
        confidence_interval*: tuple[ci_l, ci_u: float]


proc unequal_variance_z_test*(x1, x2: seq[SomeNumber], expected_mean: float = 0.0, confidence_interval_alpha: float = 0.05): UnequalVarianceZTestSummary =
    #[
        'Z-tests test the mean of a distribution.

        For the Z-test to be applicable, certain conditions must be met.
        - Nuisance parameters should be known, or estimated with high accuracy 
        (an example of a nuisance parameter would be the standard deviation in a one-sample location test). 
        Z-tests focus on a single parameter, and treat all other unknown parameters as being fixed at their true values. 
        In practice, due to Slutsky's theorem, "plugging in" consistent estimates of nuisance parameters can be justified. 
        However if the sample size is not large enough for these estimates to be reasonably accurate, 
        the Z-test may not perform well.
        - The test statistic should follow a normal distribution. 
        Generally, one appeals to the central limit theorem to justify assuming that a 
        test statistic varies normally. There is a great deal of statistical research on the 
        question of when a test statistic varies approximately normally. If the variation of the 
        test statistic is strongly non-normal, a Z-test should not be used.' ~ Wikipedia
        
        - Z and s are independent.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Z-test#Conditions
    ]#
    let 
        x1_number_observations = x1.len
        x2_number_observations = x2.len
        x_observed_mean = mean(x1) - mean(x2)
        x_standard_error = sqrt(variance(x1) / x1_number_observations.float + variance(x2) / x2_number_observations.float)
        x_z_statistic = (x_observed_mean - expected_mean) / x_standard_error
        x_p_value = (2 * (1.0 - initNormalDistribution().cdf(abs(x_z_statistic)))).round(14)
        x_z_confidence_interval = initNormalDistribution().ppf(1 - confidence_interval_alpha / 2.0)
        x_confidence_interval = ((x_observed_mean - x_z_confidence_interval * x_standard_error).round(14), (x_observed_mean + x_z_confidence_interval * x_standard_error).round(14))
    
    return UnequalVarianceZTestSummary(x1_number_observations: x1_number_observations,
                                       x2_number_observations: x2_number_observations,
                                       observed_mean: x_observed_mean,
                                       expected_mean: expected_mean,
                                       standard_error: x_standard_error,
                                       z_statistic: x_z_statistic,
                                       p_value: x_p_value,
                                       confidence_interval: x_confidence_interval)
