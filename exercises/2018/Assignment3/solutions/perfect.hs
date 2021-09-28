factors n = [x | x <- [1..n-1], mod n x == 0 ]

isPerfect n = sum (factors n) == n

perfectNumbers n m  = [x | x <- [n+1..m-1], isPerfect x]
