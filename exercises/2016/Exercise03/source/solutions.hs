import           Test.HUnit
import           Data.List

-- Exercise 1
isPrime x = not (elem 0 (map (mod x) [2..x-1]))

-- Exercise 2
sumOfSquares x = sum (map (\x -> x*x) [1..x])

squareOfSum x = sum([1..x])^2

diffSquareOfSumAndSumOfSquares x = (squareOfSum x) - (sumOfSquares x)

-- Exercise 3
insertNode x list = concat [(fst tupple), [x], (snd tupple)] where
	tupple = splitAt x list

deleteNode p list = filter (not . p) list

removeDuplicates :: Eq a => [a] -> [a]
removeDuplicates = rdHelper []
    where rdHelper seen [] = seen
          rdHelper seen (x:xs)
              | x `elem` seen = rdHelper seen xs
              | otherwise = rdHelper (seen ++ [x]) xs

sumNodes = sum

mapList = map

mergeList xs ys = sort (xs ++ ys)

sortList x = sort x
-- TESTS
tests = TestList [
  -- exercise 1
  (TestCase (assertEqual "nope!" True (isPrime 1 ))),
  (TestCase (assertEqual "nope!" True (isPrime 2 ))),
  (TestCase (assertEqual "nope!" True (isPrime 3 ))),
  (TestCase (assertEqual "nope!" True (isPrime 7 ))),
  (TestCase (assertEqual "nope!" True (isPrime 11 ))),
  (TestCase (assertEqual "nope!" False (isPrime 6 ))),
  (TestCase (assertEqual "nope!" False (isPrime 9 ))),
  (TestCase (assertEqual "nope!" False (isPrime 4 ))),
  (TestCase (assertEqual "nope!" False (isPrime 8 ))),
  (TestCase (assertEqual "nope!" False (isPrime 12 ))),

  -- exercise 2
  (TestCase (assertEqual "nope!" 2640     (diffSquareOfSumAndSumOfSquares  10 ))),
  (TestCase (assertEqual "nope!" 25164150 (diffSquareOfSumAndSumOfSquares 100 ))),

  -- exercise 3
  (TestCase (assertEqual "nope!" [1,2,2,3] (insertNode 2 [1..3]))),
  (TestCase (assertEqual "nope!" [1,2,3,4] (insertNode 4 [1..3]))),
  (TestCase (assertEqual "nope!" [1,1,2,3] (insertNode 1 [1..3]))),

  (TestCase (assertEqual "nope!" [2,4] (deleteNode odd [1..5]))),
  (TestCase (assertEqual "nope!" [1..5] (deleteNode (\x -> x > 5) [1..5]))),

  (TestCase (assertEqual "nope!" [1,2,3,4,5] (removeDuplicates [1,1,2,3,3,4,5,1,3,5]))),
  (TestCase (assertEqual "nope!" [1,2,3,4,5] (removeDuplicates [1..5]))),

  (TestCase (assertEqual "nope!" 15 (sumNodes [1..5]))),
  (TestCase (assertEqual "nope!" [True, False, True, False, True]  (mapList odd [1..5]))),
  (TestCase (assertEqual "nope!" [1..5]  (mergeList [1, 3, 5]  [2, 4]))),
  (TestCase (assertEqual "nope!" [1..5] (sortList [5,4,1,3,2]))),

  -- saniti check
  (TestCase (assertEqual "" True  True )) ]

run = do runTestTT tests
main = run
