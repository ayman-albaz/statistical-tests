type
    Submodule* = object
        name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import distributions/t
import math

import seq_math_utils
import math_utils


type
    OneSampleTTestSummary* = object
        number_observations*, degrees_freedom*: int
        observed_mean*, expected_mean*, standard_error*, t_statistic*, p_value*: float


proc one_sample_t_test*(x: seq[SomeNumber], expected_mean: float = 0.0): OneSampleTTestSummary =
    #[
        Performs a one sample t test.
        Currently, t tests in this module do not output a confidence interval.

        'The t-test can be used, for example, to determine if the means of two sets of data 
        are significantly different from each other. 

        The assumptions underlying a t-test in the simplest form above are that:
        - X follows a normal distribution with mean μ and variance σ2/n
        - s2(n − 1)/σ2 follows a χ2 distribution with n − 1 degrees of freedom. 
        This assumption is met when the observations used for estimating s2 
        come from a normal distribution (and i.i.d for each group).
        - Z and s are independent.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Student%27s_t-test#Assumptions
    ]#
    let 
        x_number_observations = x.len
        x_degrees_freedom = x_number_observations - 1
        x_observed_mean = mean(x)
        x_standard_error = standard_deviation(x) / x_number_observations.float.sqrt()
        x_t_statistic = (x_observed_mean - expected_mean) / x_standard_error
        x_p_value = (2 * (1.0 - initTDistribution(x_degrees_freedom).cdf(abs(x_t_statistic)))).round(14)
        
    return OneSampleTTestSummary(number_observations: x_number_observations,
                                 degrees_freedom: x_degrees_freedom,
                                 observed_mean: x_observed_mean,
                                 expected_mean: expected_mean,
                                 standard_error: x_standard_error,
                                 t_statistic: x_t_statistic,
                                 p_value: x_p_value)


type
    EqualVarianceTTestSummary* = object
        x1_number_observations*, x2_number_observations*, degrees_freedom*: int
        observed_mean*, expected_mean*, standard_error*, t_statistic*, p_value*: float


proc equal_variance_t_test*(x1, x2: seq[SomeNumber], expected_mean: float = 0.0): EqualVarianceTTestSummary =
    #[
        Performs an equal variance t test.
        Currently, t tests in this module do not output a confidence interval.

        'The t-test can be used, for example, to determine if the means of two sets of data 
        are significantly different from each other. 

        In the t-test comparing the means of two independent samples, the following assumptions should be met:
        - The means of the two populations being compared should follow normal distributions. 
        Under weak assumptions, this follows in large samples from the central limit theorem, 
        even when the distribution of observations in each group is non-normal.
        - If using Student's original definition of the t-test, 
        the two populations being compared should have the same variance 
        (testable using F-test, Levene's test, Bartlett's test, or the Brown–Forsythe test; 
        or assessable graphically using a Q–Q plot). If the sample sizes in the two groups 
        being compared are equal, Student's original t-test is highly robust to the presence 
        of unequal variances. Welch's t-test is insensitive to equality of the variances regardless 
        of whether the sample sizes are similar.
        - The data used to carry out the test should either be sampled independently 
        from the two populations being compared or be fully paired. This is in general not 
        testable from the data, but if the data are known to be dependent (e.g. paired by test design), 
        a dependent test has to be applied. For partially paired data, the classical independent t-tests 
        may give invalid results as the test statistic might not follow a t distribution, while the dependent 
        t-test is sub-optimal as it discards the unpaired data.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Student%27s_t-test#Assumptions
    ]#
    let 
        x1_number_observations = x1.len
        x2_number_observations = x2.len
        x_degrees_freedom = x1_number_observations + x2_number_observations - 2
        x_observed_mean = mean(x1) - mean(x2)
        x_standard_error = sqrt(pooled_variance(x1, x2) * (1 / x1_number_observations + 1 / x2_number_observations))
        x_t_statistic = (x_observed_mean - expected_mean) / x_standard_error
        x_p_value = (2 * (1.0 - initTDistribution(x_degrees_freedom).cdf(abs(x_t_statistic)))).round(14)
        
    return EqualVarianceTTestSummary(x1_number_observations: x1_number_observations,
                                     x2_number_observations: x2_number_observations,
                                     degrees_freedom: x_degrees_freedom,
                                     observed_mean: x_observed_mean,
                                     expected_mean: expected_mean,
                                     standard_error: x_standard_error,
                                     t_statistic: x_t_statistic,
                                     p_value: x_p_value)


type
    UnequalVarianceTTestSummary* = object
        x1_number_observations*, x2_number_observations*: int
        degrees_freedom*, observed_mean*, expected_mean*, standard_error*, t_statistic*, p_value*: float


proc unequal_variance_t_test*(x1, x2: seq[SomeNumber], expected_mean: float = 0.0): UnequalVarianceTTestSummary =
    #[
        Performs an unequal variance t test.
        Currently, t tests in this module do not output a confidence interval.

        'The t-test can be used, for example, to determine if the means of two sets of data 
        are significantly different from each other. 

        In the t-test comparing the means of two independent samples, the following assumptions should be met:
        - The means of the two populations being compared should follow normal distributions. 
        Under weak assumptions, this follows in large samples from the central limit theorem, 
        even when the distribution of observations in each group is non-normal.
        - If using Student's original definition of the t-test, 
        the two populations being compared should have the same variance 
        (testable using F-test, Levene's test, Bartlett's test, or the Brown–Forsythe test; 
        or assessable graphically using a Q–Q plot). If the sample sizes in the two groups 
        being compared are equal, Student's original t-test is highly robust to the presence 
        of unequal variances. Welch's t-test is insensitive to equality of the variances regardless 
        of whether the sample sizes are similar.
        - The data used to carry out the test should either be sampled independently 
        from the two populations being compared or be fully paired. This is in general not 
        testable from the data, but if the data are known to be dependent (e.g. paired by test design), 
        a dependent test has to be applied. For partially paired data, the classical independent t-tests 
        may give invalid results as the test statistic might not follow a t distribution, while the dependent 
        t-test is sub-optimal as it discards the unpaired data.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Student%27s_t-test#Assumptions
    ]#
    let 
        x1_number_observations = x1.len
        x2_number_observations = x2.len
        x1_var = variance(x1)
        x2_var = variance(x2)
        x_degrees_freedom = pow2(x1_var / x1_number_observations.float + x2_var / x2_number_observations.float) / (pow2(x1_var / x1_number_observations.float) / (x1_number_observations.float - 1) + pow2(x2_var / x2_number_observations.float) / (x2_number_observations.float - 1))
        x_observed_mean = mean(x1) - mean(x2)
        x_standard_error = sqrt(x1_var / x1_number_observations.float + x2_var / x2_number_observations.float)
        x_t_statistic = (x_observed_mean - expected_mean) / x_standard_error
        x_p_value = (2 * (1.0 - initTDistribution(x_degrees_freedom.round().int).cdf(abs(x_t_statistic)))).round(14)
        
    return UnequalVarianceTTestSummary(x1_number_observations: x1_number_observations,
                                       x2_number_observations: x2_number_observations,
                                       degrees_freedom: x_degrees_freedom,
                                       observed_mean: x_observed_mean,
                                       expected_mean: expected_mean,
                                       standard_error: x_standard_error,
                                       t_statistic: x_t_statistic,
                                       p_value: x_p_value)
