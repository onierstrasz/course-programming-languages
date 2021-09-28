import Test.HUnit

deleteRepetitions [] = []
deleteRepetitions (x:xs) 
   | xs == [] = [x]
   | otherwise = compareElementAndList x xs -- xs has at least one element

compareElementAndList n [] = [n]
compareElementAndList n (x:xs) -- xs may be an empty list
   | n /= x = n : compareElementAndList x xs
   | n == x = compareElementAndList x xs

-- TESTS
tests = TestList [

  -- exercise 4
  (TestCase (assertEqual "not correct" [4, 5, 2, 11, 2] (deleteRepetitions [4, 5, 5, 2, 11, 11, 11, 2, 2]))),
  (TestCase (assertEqual "not correct" [3, 6, 3, 7, 5] (deleteRepetitions [3, 6, 3, 7, 5]))),

  -- default check
  (TestCase (assertEqual "" True  True )) ]

run = do runTestTT tests
main = run