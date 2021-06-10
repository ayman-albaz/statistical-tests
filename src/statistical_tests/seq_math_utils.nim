import math
import sequtils

import math_utils


{.nanChecks: on, infChecks: on.}
proc mean*(x: seq[SomeNumber]): float {.inline.} =
    return sum(x).float / x.len.float


proc unscaled_variance*(x: seq[SomeNumber]): float {.inline.} = 
    let x_mean: float = mean(x)
    var total: float = 0.0
    for v in x: total += pow2(v.float - x_mean)
    return total


proc variance*(x: seq[SomeNumber], df: int = 1): float {.inline.} = 
    return unscaled_variance(x) / (x.len - df).float


proc pooled_variance*(x1, x2: seq[SomeNumber]): float {.inline.} = 
    return (unscaled_variance(x1) + unscaled_variance(x2)) / (x1.len + x2.len - 2).float


proc standard_deviation*(x: seq[SomeNumber], df: int = 1): float {.inline.} =
    return sqrt(variance(x, df))


proc sum*[T: SomeNumber](X: seq[seq[T]]): T = 
    var total: T = 0
    for x in X: 
        for v in x: 
            total += v
    return total

proc sum*[T: SomeNumber](X: seq[seq[T]], axis: int): seq[T] =
    #[
        Axis=0 means take the sum of each row
        Axis=1 means take the sum of each column
    ]#
    if axis == 0:
        var total: seq[T] = newSeq[T](X.len)
        for i in 0..<X.len:
            total[i] += sum(X[i])
        return total
    elif axis == 1:
        var total: seq[T] = newSeq[T](X[0].len)
        for i in 0..<X[0].len:
            var subtotal: T = 0
            for j in 0..<X.len: 
                subtotal += X[j][i]
            total[i] = subtotal
        return total


proc dot*[T: SomeNumber](x1, x2: seq[T]): seq[seq[T]] =
    #[
        Treats x1 as n x 1 and x2 ans 1 x n
    ]#
    var X = newSeqWith(x1.len, newSeq[T](x2.len))
    for i in 0..<x1.len:
        for j in 0..<x2.len:
            X[i][j] = x1[i] * x2[j]
    return X


proc divide*[T: SomeNumber, S: SomeNumber](X: seq[seq[T]], v: S): seq[seq[float]] =
    var X_new = newSeqWith(X.len, newSeq[float](X[0].len))
    for i in 0..<X.len:
        for j in 0..<X[0].len:
            X_new[i][j] = X[i][j].float / v.float
    return X_new


proc flatten*[T: SomeNumber](X: seq[seq[T]]): seq[T] =
    let
        m = X.len
        n = X[0].len
    var X_flat: seq[T] = newSeq[T](m * n)
    for i in 0..<X.len:
        for j in 0..<X[0].len:
            X_flat[i * n + j] = X[i][j]
    return X_flat