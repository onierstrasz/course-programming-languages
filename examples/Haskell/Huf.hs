
-- Huffmann

-- 19.9.97 -- first version (with fc0)
-- 21.9.97 -- variants to handle stack overflow (fc1-fc3)
-- 29.9.97 -- adapted to hugs 1.4 (Franz Achermann)
-- 2001-02-28 -- adapted to hugs 98 (omn)

-- 2016-02-18 -- BROKEN with Haskell 7.10.3 :-(

-- (c) Oscar Nierstrasz
-- inspired by examples in Abelson & Sussman and ... & Ducasse

-- import IO
-- import Trace
import HUnit

-- =======================================================
-- ===== Constants =======================================

iam = "\"I am what I am.\""

-- =======================================================
-- ===== char counts =====================================

-- Each Char appears Int (>0) times in some text
type CharCount = (Char,Int)

-- Compute a [CharCount] for a String
freqCount :: String -> [CharCount]
freqCount "" = []
freqCount (c:s) = incCount c (freqCount s)

-- unfortunately mac hugs does not have good tracing support!
{-
freqCount "" = trace ("=> []\n") []
freqCount (c:s) = trace ("=> incCount " ++ [c] ++ " (freqCount " ++ s ++ ")\n")
    (incCount c (freqCount s))
-}

fc0 = freqCount -- works, but large inputs overflow stack!

-- Increment the [CharCount] for a given Char
-- this turns out to be "too lazy"
incCount :: Char -> [CharCount] -> [CharCount]
incCount c [] = [(c,1)]
incCount c ((c1,n):ccList)
        | c == c1               = (c1,n+1):ccList
        | otherwise             = (c1,n):(incCount c ccList)

-- =======================================================
-- ===== generic tester ==================================

testFC name fc = let result = fc iam in
        Test (name ++ "length")
            (\x -> length result == 9)
    :+:    Test (name ++ "sum")
            (\x -> sum (map snd result) == 17)
    :+:    Test (name ++ "lookup")
            (\x -> lookup 'a' result == Just 3)

-- length, map, snd, lookup and Just are standard

-- =======================================================
-- ===== variants ========================================

fc1 s = fcTR s [] -- slightly faster, still overflows stack

-- tail-recursive frequency count
fcTR :: String -> [CharCount] -> [CharCount]
fcTR "" ccList  = ccList
fcTR (c:s) ccList = fcTR s (incCount c ccList)

-- for DEBUGGING
showCC [] = ""
showCC ((c,n):cclist) = c:(showCC cclist)

-- eager, tail-recursive frequency counter
-- fcEager (c:s) front back -- front does not contain c
fcEager :: String -> [CharCount] -> [CharCount] -> [CharCount]
fcEager "" [] ccl = ccl
fcEager (c:s) front [] = fcEager s [] ((c,1):front)
fcEager (c:s) front ((c1,n):back)
        | (c == c1)             = fcEager s [] (front ++ ((c,n+1):back))
        | otherwise             = fcEager (c:s) ((c1,n):front) back

fc2 s = fcEager s [] []

-- eager, tail-recursive, with HO front
-- avoid concatenating front and back
-- by making front a function that instantiates a list
emptyFront l = l

fcHO :: String -> ([CharCount] -> [CharCount]) -> [CharCount] -> [CharCount]
fcHO "" front back = front back
fcHO (c:s) front [] = fcHO s emptyFront (front [(c,1)])
fcHO (c:s) front ((c1,n):back)
        | (c == c1)             = fcHO s emptyFront (front ((c,n+1):back))
        | otherwise             = fcHO (c:s) (\l -> front ((c1,n):l)) back

fc3 s = fcHO s emptyFront [] -- faster than fc2, slower than fc1

-- =======================================================
-- ===== Trees ===========================================

data Tree a     = Leaf a
                | Tree a :^: Tree a
        deriving Show

-- Weigh a Tree
weight :: Tree CharCount -> Int
weight (Leaf (ch,n)) = n
weight (tree1 :^: tree2) = (weight tree1) + (weight tree2)

testWeight = Test "weight"
    (\x -> sum (map weight (map Leaf (freqCount iam))) == 17)

-- Recursively merge smallest trees together
-- till a single tree results
mergeTrees :: [Tree CharCount] -> Tree CharCount
mergeTrees [tree] = tree
mergeTrees (tree1:tree2:treeList)
        | w1 < w2       = mt treeList tree1 tree2 []
        | otherwise     = mt treeList tree2 tree1 []
                        where { w1 = (weight tree1);
                                w2 = (weight tree2) }

-- Helper function joins two smallest subtrees
-- Usage: mt untested tr1 tr2 tested
--              untested = list of trees to test
--              tr1     = smallest tree so far
--              tr2     = next smallest tree so far
--              tested  = list of trees bigger than tr1 or tr2

mt [] tr1 tr2 [] = tr1 :^: tr2
mt [] tr1 tr2 tested = mergeTrees ((tr1 :^: tr2):tested)
mt (tr3:untested) tr1 tr2 tested
        | w3 < w1       = mt untested tr3 tr1 (tr2:tested)
        | w3 < w2       = mt untested tr1 tr3 (tr2:tested)
        | otherwise     = mt untested tr1 tr2 (tr3:tested)
                        where { w1 = (weight tr1);
                                w2 = (weight tr2);
                                w3 = (weight tr3) }

-- Strip out the character counts from a Tree of CharCounts
charTree :: Tree CharCount -> Tree Char
charTree (Leaf (ch,n)) = Leaf ch
charTree (tr1 :^: tr2) = (charTree tr1) :^: (charTree tr2)

-- Generate an optimal Huffmann encoding tree for a piece of text
huf :: String -> Tree Char
huf text = charTree (mergeTrees (map Leaf (freqCount text)))
huf2 text = charTree (mergeTrees (map Leaf (fc2 text)))
huf3 text = charTree (mergeTrees (map Leaf (fc3 text)))

fchuf fc text = charTree (mergeTrees (map Leaf (fc text)))

-- =======================================================
-- ===== Encoding ========================================

-- From a Huffmann tree, generate the encoding map
mkEncode :: String -> (Tree Char) -> [(Char, String)]
mkEncode prefix (Leaf ch) = [(ch, prefix)]
mkEncode prefix (tr1 :^: tr2) =
        (mkEncode (prefix ++ "0") tr1) ++
        (mkEncode (prefix ++ "1") tr2)

-- lookup a char in an encoding map
encChar :: [(Char, String)] -> Char -> String
encChar [] _ = undefined                        -- should never happen!
encChar ((ch,str):table) c
        | c == ch       = str
        | otherwise     = encChar table c

encode :: Tree Char -> String -> String
encode tree text = foldr (++) "" (map (encChar (mkEncode "" tree)) text)

tbl fc text = mkEncode "" (fchuf fc text)

-- =======================================================
-- ===== Decoding ========================================

decode :: Tree Char -> String -> String
decode tree = walk tree tree

walk :: Tree Char -> Tree Char -> String -> String
walk tree (tr1 :^: tr2) ('0':rest) = walk tree tr1 rest
walk tree (tr1 :^: tr2) ('1':rest) = walk tree tr2 rest
walk tree (Leaf ch) rest = [ch] ++ walk tree tree rest
walk tree nav [] = []

-- next line for debugging:
-- walk tree nav (' ':rest) = walk tree nav rest

testDec text = decode tree (encode tree text)
        where tree = huf text

-- =======================================================
-- test encode/decode

testHuf text = Test "huf encode/decode"
    (\x -> decode (huf text) (encode (huf text) text) == text)

-- =======================================================
-- ===== Representing trees ==============================

-- Show a Tree Char as a Lisp-style parenthesized string
showTree :: Tree Char -> String
showTree (Leaf ch)
        | ch == '('     = "\\("
        | ch == ')'     = "\\)"
        | ch == '\\'    = "\\\\"
        | ch == '\n'    = "\\n"
        | otherwise     = [ch]
showTree (tr1 :^: tr2) = "(" ++ (showTree tr1) ++ (showTree tr2) ++ ")"

-- Parse a Lisp-style parenthesized string, generating a Tree Char
parseTree :: String -> Tree Char
parseTree = pt []

-- parseTree encodedTree = pt [] encodedTree

pt :: [Tree Char] -> String -> Tree Char
pt [tree] [] = tree
pt stack (ch:str)
        | ch == '('     = pt stack str
        | ch == ')'     = pt (join stack) str
        | ch == '\\'    = pt (Leaf (unescape (head str)):stack) (tail str)
        | otherwise     = pt (Leaf ch:stack) str

-- join the top two trees of the stack into one
join :: [Tree a] -> [Tree a]
join (tr1:tr2:stack) = (tr2:^:tr1):stack

-- unescape the character following a backslash
unescape :: Char -> Char
unescape '('    = '('
unescape ')'    = ')'
unescape '\\'   = '\\'
unescape 'n'    = '\n'

testParse text = decode (parseTree (showTree tree)) (encode tree text)
                        where tree = huf text

-- =======================================================
-- ===== Saving files ====================================

-- reads a plain text file and generates the cipher and tree files
enc :: FilePath -> IO ()
enc plain = do
                treefile <- return (plain ++ ".huf")
                cipher <- return (plain ++ ".enc")
                contents <- readFile plain
                tree <- return (huf contents)
                writeFile treefile (showTree tree)
                writeFile cipher (encode tree contents)
                putStr "Done."

dec :: FilePath -> IO()
dec plain = do
                treefile <- return (plain ++ ".huf")
                cipher <- return (plain ++ ".enc")
                contents <- readFile treefile
                tree <- return (parseTree contents)
                text <- readFile cipher
                writeFile plain (decode tree text)
                putStr "Done."


-- reads a plain text file and generates the cipher and tree files
enc2 :: FilePath -> IO ()
enc2 plain = do
                treefile <- return (plain ++ ".huf")
                cipher <- return (plain ++ ".enc")
                contents <- readFile plain
                tree <- return (huf2 contents)
                writeFile treefile (showTree tree)
                writeFile cipher (encode tree contents)
                putStr "Done."

-- =======================================================
-- ===== Tests ===========================================

tests =
        testFC "fc0" fc0
    :+:    testFC "fc1" fc1
    :+:    testFC "fc2" fc2
    :+:    testFC "fc3" fc3
    :+: testWeight
    :+: testHuf iam
    -- :+: testHuf "" -- fails!
    :+: testHuf "abcdefghijklmnopqrstuvwxyz"

-- run all the tests with runhugs:
main = do
    assert "Huf" tests

-- ==================================================

