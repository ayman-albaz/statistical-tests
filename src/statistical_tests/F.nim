type
    Submodule* = object
        name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import distributions/F
import math

import seq_math_utils


type
    FTestSummary* = object
        x1_number_observations*, x2_number_observations*, x1_degrees_freedom*, x2_degrees_freedom*: int
        F_statistic*, p_value*: float
        confidence_interval*: tuple[ci_l, ci_u: float]


proc F_test*(x1, x2: seq[SomeNumber], confidence_interval_alpha: float = 0.05): FTestSummary =
    #[
        Performs a two-tailed F test.

        'Common examples of the use of F-tests include the study of the following cases:
         - The hypothesis that the means of a given set of normally distributed populations, all having the same standard deviation, are equal. This is perhaps the best-known F-test, and plays an important role in the analysis of variance (ANOVA).
         - The hypothesis that a proposed regression model fits the data well. See Lack-of-fit sum of squares.
         - The hypothesis that a data set in a regression analysis follows the simpler of two proposed linear models that are nested within each other.

        The F-test is sensitive to non-normality. In the analysis of variance (ANOVA), 
        alternative tests include Levene's test, Bartlett's test, and the Brown–Forsythe test. 
        However, when any of these tests are conducted to test the underlying 
        assumption of homoscedasticity (i.e. homogeneity of variance), as a preliminary step 
        to testing for mean effects, there is an increase in the experiment-wise Type I error rate.' ~ Wikipedia
        https://en.wikipedia.org/wiki/F-test
    ]#
    let 
        x1_number_observations = x1.len
        x2_number_observations = x2.len
        x1_degrees_freedom = x1_number_observations - 1
        x2_degrees_freedom = x2_number_observations - 1
        x1_variance = variance(x1) 
        x2_variance = variance(x2)
        x_F_statistic = x1_variance / x2_variance
        x_p_value = (2 * (1.0 - initFDistribution(x1_degrees_freedom, x2_degrees_freedom).cdf(abs(x_F_statistic)))).round(14)
        x_confidence_interval_upper = x_F_statistic * initFDistribution(x2_degrees_freedom, x1_degrees_freedom).ppf(1 - confidence_interval_alpha / 2)
        x_confidence_interval_lower = x_F_statistic / initFDistribution(x1_degrees_freedom, x2_degrees_freedom).ppf(1 - confidence_interval_alpha / 2)
        x_confidence_interval = (x_confidence_interval_lower.round(14), x_confidence_interval_upper.round(14))

    return FTestSummary(x1_number_observations: x1_number_observations,
                        x2_number_observations: x2_number_observations,
                        x1_degrees_freedom: x1_degrees_freedom,
                        x2_degrees_freedom: x2_degrees_freedom,
                        F_statistic: x_F_statistic,
                        p_value: x_p_value,
                        confidence_interval: x_confidence_interval)
