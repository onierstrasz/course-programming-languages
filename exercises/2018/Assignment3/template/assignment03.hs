import Test.HUnit

-- Exercise 1
firstNCatalan n = undefined

-- Exercise 2
perfectNumbers n m = undefined

-- Exercise 3
insert i n l = undefined

-- Exercise 4
indexes n l = undefined

-- TESTS
tests = TestList [
  -- exercise 1
  (TestCase (assertEqual "not correct" [1, 1] (firstNCatalan 1 ))),
  (TestCase (assertEqual "not correct" [1, 1, 2, 5, 14, 42, 132] (firstNCatalan 6 ))),

  -- exercise 2
  (TestCase (assertEqual "not correct" [6]     (perfectNumbers 1 28))),
  (TestCase (assertEqual "not correct" [6, 28] (perfectNumbers 1 29 ))),

  -- exercise 3
  (TestCase (assertEqual "not correct" [1, 2, 3, 4, 5] (insert 0 1 [2..5]))),
  (TestCase (assertEqual "not correct" [2, 3, 4, 5, 1] (insert 7 1 [2..5]))),

  -- exercise 4
  (TestCase (assertEqual "not correct" [] (indexes 1 [0,0,0]))),
  (TestCase (assertEqual "not correct" [0, 5] (indexes 6 [6, 3, 4, 5, 1, 6, 5]))),

  -- default check
  (TestCase (assertEqual "" True  True )) ]

run = do runTestTT tests
main = run