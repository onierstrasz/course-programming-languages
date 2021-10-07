
import HUnit

-- ==================================================
-- Lecture 3: Functional programming
-- ==================================================
-- declarative style

fac n =
    if      n == 0
    then    1
    else    n * fac(n-1)

sqr n = n * n

-- ==================================================
-- tail recursion

sfac s n =
    if n == 0 then s
    else sfac (s*n) (n-1)

-- equational reasoning: fac == sfac 1

-- ==================================================
-- patterns and guards
fac' 0 = 1
fac' n = n * fac'(n-1)

fac'' n    | n == 0        = 1
           | n >= 1        = n * fac'' (n-1)

-- ==================================================
-- using lists

head' (x:_) = x

len [ ]     = 0
len (x:xs)  = 1 + len xs

-- NB: [1,2,3,4] == 1:2:3:4:[]

prod [ ]            = 1
prod (x:xs)         = x * prod xs

fac''' n            = prod [1..n]

-- ==================================================
-- higher-order functions

map' f []    = []
map' f (x:xs)    = f x : map' f xs

mfac = map' fac

-- map' fac [1..5]

square :: Int -> Int
square x = x * x

square' :: Int -> Int
square' = (\x -> x * x)

-- map (\x -> x * x) [1..10]

-- ==================================================
-- curried functions

plus x y = x + y

inc = plus 1

-- currying + HO functions
fac'''' = sfac 1
    where sfac s n
           |  n == 0    = s
           |  n >= 1    = sfac (s*n) (n-1)

-- NB different from sfac (s,n)

-- same as plus
plus'' x = \y -> x+y

-- ==================================================
-- currying

curry' f a b    = f (a,b)

plus'(x,y) = x + y
inc' = curry plus' 1

sfac' (s, n) =
    if n == 0 then s
    else sfac' (s*n, n-1)
fac''''' = (curry sfac') 1

-- ==================================================
-- multiple recursion

fib 1 = 1
fib 2 = 1
fib n = fib (n-1) + fib (n-2)
-- fib (n+2) = fib n + fib (n+1)
-- fib 10 in 218 reds

-- vs.
fib' 1 = 1
fib' n = a                where (_,a) = fibPair n
fibPair 1 = (0,1)
fibPair n = (b,a+b)            where (a,b) = fibPair (n-1)
-- fibPair (n+2) = (b,a+b)     where (a,b) = fibPair (n+1)
-- fib' 10 -> 55 in 49 reds

-- ==================================================
-- tail-recursive fibonacci

fib'' n = trFib (n-1) 1 1
    where
        trFib 0 _ j = j
        trFib n k j = trFib (n-1) (k+j) k

-- idea: trFib i (fib (j+1)) (fib j) == fib (i+j)

-- fib'' (n+1) = trFib n 1 1
-- trFib (n+1) k j = trFib n (k+j) k
-- fib'' 10 in 20 reds

-- ==================================================
-- Lazy evaluation

ifTrue True x y = x
ifTrue False x y = y

-- ifTrue True 1 (5/0)

-- ==================================================
-- lazy lists

from n = n : from (n+1)
-- (a,b,c) where (a:b:c:_) = from 10

take' 0 _    = []
take' _ []    = []
take' n (x:xs)    = x : take' (n-1) xs
-- take' (n+1) (x:xs)    = x : take' n xs

-- take 20 (map (\x->x * x) [1..])

-- take 20 (map square' [1..])

-- ==================================================
-- programming lazy lists

fibs = 1 : 1 : fibsFollowing 1 1
    where fibsFollowing a b =
           (a+b) : fibsFollowing b (a+b)

fibs' = fibsFrom 1 1
    where fibsFrom a b =
           a : fibsFrom b (a+b)

-- take 10 fibs

-- ==================================================
-- declarative programming style

primes = primesFrom 2
primesFrom n = p : primesFrom (p+1)
    where p = nextPrime n
nextPrime n
    | isPrime n            = n
    | otherwise            = nextPrime (n+1)
isPrime 2 = True
isPrime n = notDivisible primes n
notDivisible (k:ps) n
    | (k*k) > n            = True
    | (mod n k) == 0        = False
    | otherwise            = notDivisible ps n

-- take 100 primes

-- ==================================================
-- generic tests for factorial and fibonacci

facTests fname fac =
        Test (fname ++ "0") (\x -> fac 0 == 1)
    :+: Test (fname ++ "1") (\x -> fac 1 == 1)
    :+: Test (fname ++ "5") (\x -> fac 5 == 120)
    :+: Test (fname ++ "10") (\x -> fac 10 == 3628800)

fibTests fname fib =
        Test (fname ++ "1") (\x -> fib 1 == 1)
    :+:    Test (fname ++ "2") (\x -> fib 2 == 1)
    :+:    Test (fname ++ "10") (\x -> fib 10 == 55)

-- ==================================================
-- some simple tests

ifTrueTest = Test "ifTrue" (\x -> ifTrue True 1 (5/0) == 1)

tests = facTests "fac" fac
    :+: ifTrueTest
    :+: facTests "sfac" (sfac 1)
    :+: facTests "fac'" fac'
    :+: facTests "fac''" fac''
    :+: facTests "fac'''" fac'''
    :+: fibTests "fib" fib
    :+: fibTests "fib'" fib'
    :+: fibTests "fibs" (\n -> last (take n fibs))
    :+: Test "primes" (\n -> (take 5 primes) ==    [2,3,5,7,11])

-- run all the tests with runhugs:
main = do
    assert "Intro" tests

-- ==================================================
