--ex1
fib 1 = 1
fib 2 = 1
fib x = fib (x-1) + fib (x-2)

fibSeq = map fib [1..]

isInFib x = isInFibReq x fibSeq where
        isInFibReq n (x:xs)
                | n == x = True
                | n <  x = False
                | otherwise = isInFibReq n xs


--ex2
lst = [1..1000]
mod3 x = (mod x 3 == 0)
filtLst = filter mod3 lst
sum filtLst
