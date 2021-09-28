fac n
   | n == 0 = 1
   | otherwise = n * fac (n-1)
   
catalan n
   | n >= 0 = fac (2*n) / (fac n * fac (n+1))
   
firstNCatalan n = [catalan x |x <-[0..n]]


   