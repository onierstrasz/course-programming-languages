indexes a l = indexesFrom 0 a l

indexesFrom i n [] = []
indexesFrom i n (x:xs)
   | x == n = i : indexesFrom (i+1) n xs
   | otherwise = indexesFrom (i+1) n xs