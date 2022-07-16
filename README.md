![Linux Build Status (Github Actions)](https://github.com/ayman-albaz/statistical-tests/actions/workflows/install_and_test.yml/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Statistical Tests
Statistical tests is a Nim library for performing statistical tests.

## Supported Statistical Tests
| Statistical Test  | Command                                                                                                                      |
|-------------------|------------------------------------------------------------------------------------------------------------------------------|
| Binomial Test           | `binomialTest(x, n: int, p:float, confidenceIntervalAlpha: float = 0.05)`                                             |
| Chi2 Test               | `chi2Test(observedValues: seq[SomeNumber], expectedValues: seq[SomeNumber], confidenceIntervalAlpha: float = 0.05)` |
| Chi2 Contingency Test   | `chi2ContingencyTest(observedValues: seq[seq[SomeNumber]])`                                                            |
| F Test                  | `fTest(x1, x2: seq[SomeNumber], confidenceIntervalAlpha: float = 0.05)`                                               |
| One sample t-test       | `oneSampleTTest(x: seq[SomeNumber], expectedMean: float = 0.0, confidenceIntervalAlpha: float = 0.05)`             |
| Equal variance t-test   | `equalVarianceTTest(x1, x2: seq[SomeNumber], expectedMean: float = 0.0)`                                             |
| Unequal variance t-test | `unequalVarianceTTest(x1, x2: seq[SomeNumber], expectedMean: float = 0.0)`                                           |
| One sample z-test       | `oneSampleZTest(x: seq[SomeNumber], expectedMean: float = 0.0, confidenceIntervalAlpha: float = 0.05)`             |
| Equal variance z-test   | `equalVarianceZTest(x1, x2: seq[SomeNumber], expectedMean: float = 0.0)`                                             |
| Unequal variance z-test | `unequalVarianceZTest(x1, x2: seq[SomeNumber], expectedMean: float = 0.0)`                                           |


## Example
```Nim
let stats = oneSampleZTest([1, 2, 3, 4, 5, 6])
echo stats.numberObservations
echo stats.observedMean
echo stats.expectedMean
echo stats.standardError
echo stats.zStatistic
echo stats.pValue
echo stats.confidenceInterval
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
