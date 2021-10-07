
# Install ghc from http://hackage.haskell.org/platform/

ALL = Intro Types Huf Lambda Calc Assign Store

# Suppress some stupid warnings
# http://comments.gmane.org/gmane.comp.lang.haskell.glasgow.user/20346
NOWARN = -optl"-Wl,-no_compact_unwind,-no_pie"

all :
	@# nothing to do here

test :
	-ghc Intro.hs -e main
	-ghc Types.hs -e main
	-ghc Huf.hs -e main
	-ghc Lambda.hs -e main
	-ghc Calc.hs -e main
	-ghc Assign.hs -e main
	-ghc Store.hs -e main

clean :
	@-rm -f $(ALL)
	@-rm -f *.hi *.o

