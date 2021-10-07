
import HUnit

-- ==================================================
-- Lecture 4: Type systems
-- ==================================================
-- polymorphism

length' :: [Integer] -> Integer
length' [] = 0
length' (x:xs) = 1 + length' xs

-- ==================================================
-- recursive data types

data Tree a = Lf a | Tree a :^: Tree a
    deriving Show

leaves, leaves' :: Tree a -> [a]

leaves (Lf l) = [l]
leaves (l :^: r) = leaves l ++ leaves r

leaves' t = leavesAcc t [ ]
    where
        leavesAcc (Lf l) = (l:)
        leavesAcc (l :^: r) = leavesAcc l . leavesAcc r

mytree = (Lf 12 :^: (Lf 23 :^: Lf 13)) :^: Lf 10

-- mytree :: Tree Int

-- ==================================================
-- another List

data MyList a = Empty | a :-: MyList a

len Empty = 0
len (head :-: tail) = 1 + len tail

-- ==================================================

tests =
        Test "leaves" (\x -> leaves mytree == [12, 23, 13, 10])
    :+: Test "leaves" (\x -> leaves mytree == leaves' mytree)
    :+: Test "my empty list" (\x -> len Empty == 0)
    :+: Test "my nonempty list" (\x -> len (1 :-: (2 :-: Empty)) == 2)

-- run all the tests with runhugs:
main = do
    assert "Type" tests

-- ==================================================
