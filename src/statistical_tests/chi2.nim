type
    Submodule* = object
        name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import distributions/chi2
import math
import sequtils

import seq_math_utils
import math_utils


proc calculate_chi2[T: SomeNumber, S: SomeNumber](observed_values: seq[T], expected_values: seq[S]): float = 
    var chi2: float = 0
    for i in 0..<observed_values.len:
        chi2 += pow2(observed_values[i].float - expected_values[i].float) / expected_values[i].float
    return chi2


proc calculate_chi2_contingency_table[T: SomeNumber](observed_values: seq[seq[T]]): seq[seq[float]] = 
    var 
        total: T = sum(observed_values)
        total_rows: seq[T] = sum(observed_values, axis=0)
        total_cols: seq[T] = sum(observed_values, axis=1)
    return divide(dot(total_rows, total_cols), total)
    

type
    Chi2TestSummary*[S] = object
        number_observations*, degrees_freedom*: int
        chi2_statistic*, p_value*: float
        expected_values*: seq[S]
        confidence_interval*: tuple[ci_l, ci_u: float]


proc chi2_test*[T: SomeNumber, S: SomeNumber](observed_values: seq[T], expected_values: seq[S], confidence_interval_alpha: float = 0.05): Chi2TestSummary[S] =
    #[
        Performs a two-tailed chi2 test.

        'Pearson's chi-squared test is used to determine whether there is a statistically significant 
        difference between the expected frequencies and the observed frequencies in one or more 
        categories of a contingency table.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Chi-squared_test

        Use chi2 test when number of observations >= 5, else use fisher's test
    ]#
    let 
        x_number_observations = observed_values.len
        x_degrees_freedom = x_number_observations - 1
        x_chi2_statistic = calculate_chi2(observed_values, expected_values)
        x_confidence_interval_lower = sqrt(variance(observed_values) * x_degrees_freedom.float / initChi2Distribution(x_degrees_freedom).ppf(1 - confidence_interval_alpha / 2))
        x_confidence_interval_upper = sqrt(variance(observed_values) * x_degrees_freedom.float / initChi2Distribution(x_degrees_freedom).ppf(confidence_interval_alpha / 2))
        x_confidence_interval = (x_confidence_interval_lower.round(14), x_confidence_interval_upper.round(14))
        x_p_value = (1.0 - initChi2Distribution(x_degrees_freedom).cdf(abs(x_chi2_statistic))).round(14)
        
    return Chi2TestSummary[S](number_observations: x_number_observations,
                              degrees_freedom: x_degrees_freedom,
                              expected_values: expected_values,
                              chi2_statistic: x_chi2_statistic,
                              p_value: x_p_value,
                              confidence_interval: x_confidence_interval)


proc chi2_test*(observed_values: seq[SomeNumber], confidence_interval_alpha: float = 0.05): Chi2TestSummary[float] =
    #[
        Performs a two-tailed chi2 test.
        This version of the chi2 test, uses the mean of `observed_values` as the expected values array.

        'Pearson's chi-squared test is used to determine whether there is a statistically significant 
        difference between the expected frequencies and the observed frequencies in one or more 
        categories of a contingency table.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Chi-squared_test

        Use chi2 test when number of observations >= 5, else use fisher's test
    ]#
    let 
        x_expected_value = mean(observed_values)
        x_expected_values = repeat(x_expected_value, observed_values.len)
    return chi2_test(observed_values, x_expected_values, confidence_interval_alpha)



type
    Chi2ContingencyTestSummary* = object
        number_observations*, degrees_freedom*: int
        chi2_statistic*, p_value*: float
        expected_values*: seq[seq[float]]
        confidence_interval*: tuple[ci_l, ci_u: float]


proc chi2_contingency_test*(observed_values: seq[seq[SomeNumber]]): Chi2ContingencyTestSummary =
    #[
        Performs a two-tailed chi2 test using a contingency table.
        This version of the test does not provide a confidence interval.

        Each inner seq should represent a different condition, and each value within a seq should represent an outcome type.
        E.g. This is equal to seq(seq(3, 4), seq(5, 6))
                    Nothing     Recovered
            Drug       33          44
            No Drug    55          66

        'Pearson's chi-squared test is used to determine whether there is a statistically significant 
        difference between the expected frequencies and the observed frequencies in one or more 
        categories of a contingency table.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Chi-squared_test

        Each cell should be >= 5
    ]#
    let 
        x_number_rows = observed_values.len
        x_number_cols = observed_values[0].len
        x_number_observations = sum(observed_values).int
        x_degrees_freedom = (x_number_rows - 1) * (x_number_rows - 1)
        x_expected_values = calculate_chi2_contingency_table(observed_values)
        x_chi2_statistic = calculate_chi2(flatten(observed_values), flatten(x_expected_values))
        x_p_value = (1.0 - initChi2Distribution(x_degrees_freedom).cdf(abs(x_chi2_statistic))).round(14)
        
    return Chi2ContingencyTestSummary(number_observations: x_number_observations,
                                      degrees_freedom: x_degrees_freedom,
                                      expected_values: x_expected_values,
                                      chi2_statistic: x_chi2_statistic,
                                      p_value: x_p_value)

