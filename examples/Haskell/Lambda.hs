
import HUnit

-- ==================================================
-- Lecture 6: Introduction to the Lambda Calculus
-- ==================================================
-- Lambda expressions in Haskell

f1 x y = x + y

f2 = \x -> \y -> x + y

i = \x -> x

testi = Test "i" (\x -> i 5 == i i 5)

-- ==================================================
-- Representing Booleans

t = \x -> \y -> x
f = \x -> \y -> y

isTrue b = b "yes" "no"
isFalse b = b "no" "yes"

neg = \b -> b f t

testbool =    Test "isTrue" (\x -> isTrue t == "yes")
        :+: Test "neg" (\x -> isFalse (neg t) == "yes")

-- ==================================================
-- Representing Tuples

pair = \x -> \y -> \z -> z x y
first = \p -> p t
second = \p -> p f

-- first (pair 1 2)
-- first (second (pair 1 (pair 2 3)))

testpair =    Test "first" (\x -> first (pair 1 2) == 1)
        :+: Test "second" (\x -> first (second (pair 1 (pair 2 3))) == 2)

-- ==================================================
-- Representing Numbers

zero = i
succ' = \n -> pair f n
isZero = first
pred' = second

one = succ' zero
two = succ' one

-- isTrue (isZero (pred' (pred' two)))

testpred =
    Test "pred" (\x -> isTrue (isZero (pred' (pred' two))) == "yes")

-- ==================================================
-- omega:
-- \x -> x x

-- ==================================================

tests = testi :+: testbool :+: testpair :+: testpred

-- run all the tests with runhugs:
main = do
    assert "Lambda" tests

-- ==================================================
