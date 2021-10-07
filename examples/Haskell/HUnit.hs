-- ==================================================
-- A simple testing framework

module HUnit where

data Test name test =
    Test name test
    | Test name test :+: Test name test
        deriving Show

-- dotest :: Eq a => (Test String (a->b) a b) -> String
-- dotest :: Eq a => Test [Char] (b -> a) b a -> [Char]

dotest (Test name test) =
    if (test ())
    then ""
    else name ++ " FAILED\n"

dotest (t1 :+: t2) =
    (dotest t1) ++ (dotest t2)

assert name test =
    let result = dotest test
    in
        if length(result) > 0
        then putStr result
        else putStr ("PASSED " ++ name ++ " tests\n")

-- ==================================================
-- demo example:

{-
aTest =
    Test "test0" (\x -> 0 == 0)

twoTests =
        Test "test1" (\x -> 1 == 1)
    :+: Test "test2" (\x -> 2 == 2)

allTests = aTest :+: twoTests
-}

-- assert "allTests" allTests

-- ==================================================
