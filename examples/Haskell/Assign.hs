
import HUnit

-- ==================================================
-- A Language with Assignment
-- ==================================================
-- Modelling Environments

type Store = Identifier -> Int

newstore :: Store
newstore id = 0

update :: Identifier -> Int -> Store -> Store
update id val store = store'
                    where store' id'
                                | id' == id        = val
                                | otherwise        = store id'

ifelse :: Bool -> a -> a -> a
ifelse True x y = x
ifelse False x y = y

-- ==================================================
-- Representing abstract syntax trees

{-
P ::= C '.'
C ::= C1 ';' C2 | 'if' B 'then' C1 'else' C2 | I ':=' E
E ::= E1 '+' E2 | I | N
B ::= E1 '=' E2 | 'not' B

-}

data Program =
    Dot Command
        deriving Show

data Command =
    CSeq Command Command
    | Assign Identifier Expression
    | If BooleanExpr Command Command
        deriving Show

data Expression =
    Plus Expression Expression
    | Id Identifier
    | Num Int
        deriving Show

data BooleanExpr =
    Equal Expression Expression
    | Not BooleanExpr
        deriving Show

type Identifier = Char

-- ==================================================
-- Semantics of assignments

pp :: Program -> Int -> Int
pp (Dot c) n = (cc c (update 'a' n newstore)) 'z'

cc :: Command -> Store -> Store
cc (CSeq c1 c2) s = cc c2 (cc c1 s)
cc (Assign id e) s = update id (ee e s) s
cc (If b c1 c2) s = ifelse (bb b s) (cc c1 s) (cc c2 s)

ee :: Expression -> Store -> Int
ee (Plus e1 e2) s = (ee e2 s) + (ee e1 s)
ee (Id id) s = s id
ee (Num n) s = n

bb :: BooleanExpr -> Store -> Bool
bb (Equal e1 e2) s = (ee e1 s) == (ee e2 s)
bb (Not b) s = not (bb b s)

-- ==================================================

src1 = "z := 1 ; if a = 0 then z := 3 else z := z + a ."
ast1 = Dot (CSeq
            (Assign 'z' (Num 1))
                (If (Equal (Id 'a') (Num 0))
                    (Assign 'z' (Num 3))
                    (Assign 'z' (Plus (Id 'z') (Id 'a')))
                )
            )

-- generate a test for a given source code and abstract syntax tree
gentest src ast arg result = Test src
    (\x -> pp ast arg == result)

tests = gentest (src1 ++ "(0)") ast1 0 3
    :+: gentest (src1 ++ "(1)") ast1 1 2
    :+: gentest (src1 ++ "(10)") ast1 10 11

main = assert "Assign" tests

-- ==================================================
