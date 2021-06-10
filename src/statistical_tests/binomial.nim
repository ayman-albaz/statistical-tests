type
    Submodule* = object
        name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import distributions/binomial
import distributions/beta
import math


type
    BinomialTestSummary* = object
        number_successes*, number_observations*: int
        proportion*, p_value*: float
        confidence_interval*: tuple[ci_l, ci_u: float]


proc binomial_test*(x, n: int, p:float, confidence_interval_alpha: float = 0.05): BinomialTestSummary =
    #[
        Performs a two-tailed binomial test.
        Uses the clopper peasrson method to determine the confidence interval.

        'In statistics, the binomial test is an exact test of the statistical 
        significance of deviations from a theoretically expected distribution 
        of observations into two categories.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Binomial_test
    ]#
    if x > n or x < 0:
        raise newException(ValueError, "`x` must: 0 <= `x` <= n")
    let 
        x_proportion = x / n
        x_p_value = 2 * initBinomialDistribution(n, p).cdf(abs(x)).round(14)
        x_confidence_interval_lower = max(0.0, initBetaDistribution(x.float, n.float - x.float + 1.0).ppf(confidence_interval_alpha / 2))
        x_confidence_interval_upper = min(1.0, initBetaDistribution(x.float + 1.0, n.float - x.float).ppf(1 - confidence_interval_alpha / 2))
        x_confidence_interval = (x_confidence_interval_lower.round(14), x_confidence_interval_upper.round(14))
    return BinomialTestSummary(number_successes: x,
                               number_observations: n,
                               proportion: x_proportion,
                               p_value: x_p_value,
                               confidence_interval: x_confidence_interval)
