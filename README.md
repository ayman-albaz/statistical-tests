![Linux Build Status (Github Actions)](https://github.com/ayman-albaz/statistical-tests/actions/workflows/install_and_test.yml/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Statistical Tests
Statistical tests is a Nim library for performing statistical tests.

## Supported Statistical Tests
| Statistical Test  | Command                                                                                                                      |
|-------------------|------------------------------------------------------------------------------------------------------------------------------|
| Binomial Test           | binomial_test(x, n: int, p:float, confidence_interval_alpha: float = 0.05)                                             |
| Chi2 Test               | chi2_test(observed_values: seq[SomeNumber], expected_values: seq[SomeNumber], confidence_interval_alpha: float = 0.05) |
| Chi2 Contingency Test   | chi2_contingency_test(observed_values: seq[seq[SomeNumber]]                                                            |
| F Test                  | F_test(x1, x2: seq[SomeNumber], confidence_interval_alpha: float = 0.05)                                               |
| One sample t-test       | one_sample_t_test(x: seq[SomeNumber], expected_mean: float = 0.0, confidence_interval_alpha: float = 0.05)             |
| Equal variance t-test   | equal_variance_t_test(x1, x2: seq[SomeNumber], expected_mean: float = 0.0)                                             |
| Unequal variance t-test | unequal_variance_t_test(x1, x2: seq[SomeNumber], expected_mean: float = 0.0)                                           |
| One sample z-test       | one_sample_z_test(x: seq[SomeNumber], expected_mean: float = 0.0, confidence_interval_alpha: float = 0.05)             |
| Equal variance z-test   | equal_variance_z_test(x1, x2: seq[SomeNumber], expected_mean: float = 0.0)                                             |
| Unequal variance z-test | unequal_variance_z_test(x1, x2: seq[SomeNumber], expected_mean: float = 0.0)                                           |


## Example
```Nim
let stats = one_sample_z_test([1, 2, 3, 4, 5, 6])
echo stats.number_observations
echo stats.observed_mean
echo stats.expected_mean
echo stats.standard_error
echo stats.z_statistic
echo stats.p_value
echo stats.confidence_interval
```

## Accuracy
All functions in this library are accurate up-to 14 decimal places (float64).


## TODO
List is organized from most important to least important:
- Add more statistical tests on an as-need-bases.
- Some statistical tests require certain distributions from the distributions.nim library, so add more distributions there.

Performance, feature, and documentation PR's are always welcome.


## Contact
I can be reached at aymanalbaz98@gmail.com
