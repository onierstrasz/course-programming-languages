
To run these examples, install the Glasgow Haskell Compiler.

http://hackage.haskell.org/platform/

http://www.haskell.org

To run the tests, simply run "make test".

To play with the examples, run ghci (the interpreter):

oscar@macula: ghci
GHCi, version 7.10.3: http://www.haskell.org/ghc/  :? for help
Prelude> :load Intro.hs
[1 of 2] Compiling HUnit            ( HUnit.hs, interpreted )
[2 of 2] Compiling Main             ( Intro.hs, interpreted )
Ok, modules loaded: HUnit, Main.
*Main> take 10 fibs
[1,1,2,3,5,8,13,21,34,55]


-- Lecture 3: Functional programming
Intro.hs	-- Introductory Haskell examples
HUnit.hs	-- some standard test functions

-- Lecture 4: Type systems
Types.hs	-- polymorphic types, user data types

-- Lecture 5: Lambda calculus
Lambda.hs	-- Representing lambda terms in Haskell

-- Lecture 7: Denotational Semantics
Calc.hs		-- A calculator language
Assign.hs	-- A Language with Assignment
Store.hs	-- Modelling environments (examples)
[Examples from D.A. Schmidt, Denotational Semantics, 1986]

-- not used (Applications)
Huf.hs		-- Hufmann encoding
hufDemoCases -- code to copy & paste to haskell
iam			-- input for huf
HufOutput	-- sample output from running [enc "iam"] and [enc "huf"]

Oscar Nierstrasz
2004-06-05
2012-03-09
