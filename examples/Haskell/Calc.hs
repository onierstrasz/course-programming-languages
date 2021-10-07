
import HUnit

-- ==================================================
-- A Calculator Language
-- ==================================================
-- Data Structures for Abstract Syntax
{-
P of Program
S of Expr-sequence
E of Expression
N of Numeral

P ::= 'ON' S
S ::= E 'TOTAL' S | E 'TOTAL' 'OFF'
E ::= E1 '+' E2 | E1 '*' E2 | 'IF' E1 ',' E2 ',' E3 | 
    'LASTANSWER' | '(' E ')' | N
-}

data Expression =
    Plus Expression Expression
    | Times Expression Expression
    | If Expression Expression Expression
    | LastAnswer
    | Braced Expression
    | N Int
        deriving Show

data ExprSequence =
    Total Expression ExprSequence
    | TotalOff Expression
        deriving Show

data Program =
    On ExprSequence
        deriving Show

-- ==================================================
-- Implementing the Calculator semantics

pp :: Program -> [Int]
pp (On s) = ss s 0

ss :: ExprSequence -> Int -> [Int]
ss (Total e s) n = let n' = (ee e n) in n' : (ss s n') 
ss (TotalOff e) n = (ee e n) : []

ee :: Expression -> Int -> Int
ee (Plus e1 e2) n = (ee e1 n) + (ee e2 n)
ee (Times e1 e2) n = (ee e1 n) * (ee e2 n)
ee (If e1 e2 e3) n | (ee e1 n) == 0 = (ee e2 n)
            | otherwise = (ee e3 n)
ee (LastAnswer) n = n
ee (Braced e) n = (ee e n)
ee (N num) n = num

-- ==================================================
-- Test programs

src1 = "ON 4 + 7 TOTAL OFF"
ast1 = On (TotalOff (Plus (N 4) (N 7)))

src2 = "ON 4 * (3+2) TOTAL OFF"
ast2 =    On
            (TotalOff
            (Times (N 4) (Braced (Plus (N 3) (N 2))))
            )

src3 = "ON 4 * ( 3 + 2 ) TOTAL LASTANSWER + 1 TOTAL OFF"
ast3 =    On
            (Total
                (Times (N 4) (Braced (Plus (N 3) (N 2))))
                (TotalOff
                    (Plus LastAnswer (N 1))
                )
            )

tests = Test src1 (\x -> pp ast1 == [11])
    :+: Test src2 (\x -> pp ast2 == [20])
    :+: Test src3 (\x -> pp ast3 == [20, 21])

main = assert "Calc" tests

-- ==================================================
