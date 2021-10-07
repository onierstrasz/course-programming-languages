
/*
	Prolog case study -- functional dependencies and normal forms
	for relational algebra.
	
	An attribute set A is represented as a list [A1, A2, ...]
	An FD is represented as: AS1 -> AS2
*/

% ==================================================
% === closures =====================================

% redefine precedence so -> has lower precedence than = or ,
:- op(600, xfx, [ -> ]).

/*
	closure(FDS, AS, CS) -- CS is the closure of attribute set AS wrt FDS

		Use Armstrong's Axioms:
		1. B<A => A->B
		2. A->B => AC->BC
		3. A->B, B->C => A->C
		
		start with A->A', where A'=A (1)
		try to find some B->C, A'=BD => A->A'->CD (2,3)
		repeat till no more FD applies
		NB: each FD can be applied at most once!
*/

% CS is the closure of AS, using the applicable FDS
closure(FDS, AS, CS) :-
	applies(FDS, _->C, AS, FDRest), !,
	union(AS, C, AS1),
	closure(FDRest, AS1, CS).
closure(_, AS, AS).

% The FD B->C in the set of FDS applies to AS, leaving FDRest:
applies(FDS, B->C, AS, FDRest) :-
	in(B->C, FDS), rem(B->C, FDS, FDRest),
	subset(B,AS).

% --------------------------------------------------

abcFDS([
			[a]->[b,c],
			[c,g]->[h,i],
			[b,c]->[h]
		]).

testClosures :-
	abcFDS(FDS),
	closure(FDS, [a], Ca),
	check('closure[a]', equal(Ca, [a,b,c,h])),
	closure(FDS, [a,c], Cac),
	check('closure[ac]', equal(Cac, [a,b,c,h])),
	closure(FDS, [a,g], Cag),
	check('closure[ac]', equal(Cag, [a,b,c,g,h,i])).

% ==================================================
% === keys =========================================

/*
	candkey(FDS,Key) -- Key is a candidate key for attrs in FDS
	compute AS (union of all AS in FDS)
	remove elements till minimal key is found
*/

candkey(FDS, Key) :-
	attset(FDS, AS),
	minkey(FDS, AS, AS, Key).

attset([],[]).
attset([B->C|FDS],AS) :-
	union(B,C,A1),
	attset(FDS,A2),
	union(A1,A2,AS).

minkey(FDS, AS, Key, MinKey) :-
	smallerkey(FDS, AS, Key, SmallerKey), !,
	minkey(FDS, AS, SmallerKey, MinKey).
% else, stop if none smaller
minkey(_, _, MinKey, MinKey).

smallerkey(FDS, AS, Key, Smaller) :-
	in(X, Key),
	rem(X, Key, Smaller),
	% mydebug(['Trying smaller set '|Smaller]),
	iskey(Smaller, AS, FDS).

% Key is a key for att set AS wrt FDS
iskey(Key, AS, FDS) :-
	closure(FDS, Key, Closure),
	% mydebug([Key, ' -> ', Closure]),
	subset(AS, Closure).

% --------------------------------------------------

tk1 :-
	abcFDS(FDS),
	candkey(FDS, Key),
	check('candkey[ag]', equal(Key, [a,g])).

supplierFDS([[name]->[addr],[name,article]->[price]]).

tk2 :-
	supplierFDS(FDS),
	candkey(FDS, Key),
	check('candkey[name,article]', equal(Key, [name,article])).

testKeys :- tk1, tk2.

% ==================================================
% === BCNF =========================================

isbcnf(FDS, RS) :-
	fdsok(FDS, FDS, RS).


fdsok([A->B|ToCheck], FDS, RS) :-
	subset(B,A), % A->B is trivial
	fdsok(ToCheck,FDS,RS).

/* WRONG -- Thanks to David Jud for pointing out the error
fdsok([A->B|ToCheck], FDS, RS) :-
	subset(A, RS), !, % A applies to RS
	iskey(A, RS, FDS), % A is a key for RS
	fdsok(ToCheck,FDS,RS).
*/

fdsok([A->B|ToCheck], FDS, RS) :-
	subset(A, RS), inter(B, RS, X), not(X == []), !, % A applies to RS
	iskey(A, RS, FDS), % A is a key for RS
	fdsok(ToCheck,FDS,RS).

fdsok([_->_|ToCheck], FDS, RS) :- % A->B
	% not(subset(A, RS)),
	fdsok(ToCheck,FDS,RS). % A doesn't apply
fdsok([], _, _). % Nothing left to check

% --------------------------------------------------

tnf1 :-
	supplierFDS(FDS),
	SupplierScheme = [name, addr],
	SupplyScheme = [name, article, price],
	InfoScheme = [name, addr, article, price],
	check('SupplierScheme', isbcnf(FDS, SupplierScheme)),
	% check('SupplyScheme', not(isbcnf(FDS, SupplyScheme))), % WRONG
	check('SupplyScheme', isbcnf(FDS, SupplyScheme)),
	check('InfoScheme', not(isbcnf(FDS, InfoScheme))).

zipFDS([[city, street] -> [zip], [zip] -> [city]]).

tnf2 :-
	zipFDS(FDS),
	attset(FDS, As),
	check('zip', not(isbcnf(FDS, As))).

testBCNF :-
	tnf1, tnf2.

% ==================================================
% === BCNF Decomposition ===========================

bcnf(FDS, Decomp) :-
	attset(FDS, AS),
	mydebug(['Attribute set is ', AS]),
	bcnfDecomp(FDS, [AS], Decomp).

% if RS is not BCNF, decompose it:
bcnfDecomp(FDS, [RS|Schema], Decomp) :-
	findBad(A->B, FDS, FDS, RS),
	union(A,B,AB),
	diff(RS,B,Diff),
	mydebug(['Use ', A->B, ' to split ', RS, ' into ', AB, ' and ', Diff]), 
	bcnfDecomp(FDS, [AB,Diff|Schema], Decomp).

% else check the rest of schema
bcnfDecomp(FDS, [RS|Schema], [RS|Decomp]) :-
	bcnfDecomp(FDS, Schema, Decomp).

% nothing left to do
bcnfDecomp(_, [], []).

findBad(A->B, [FD|_], AllFDS, RS) :-
	FD = A->B0,
	subset(A,RS), % A->B holds on RS
	diff(B0,A,B1), % A^B should be empty
	inter(B1,RS,B), % A->B holds on RS
	not(subset(B,A)),
	% mydebug([A->B, ' is not trivial']),
	not(iskey(A, RS, AllFDS)).
	% mydebug([A, ' not a key for ', RS]).

findBad(FD, [_|FDS], AllFDS, RS) :-
	findBad(FD, FDS, AllFDS, RS).

/*
% NB: This won't find all bad FDs in the closure:
badfd(FD, FDS, RS) :-
	in(FD, FDS),
	not(fdsok([FD], FDS, RS)).
*/

% --------------------------------------------------

branchFDS([	[branchName] -> [assets, branchCity],
			[loanNumber] -> [amount, branchName],
			[customerName] -> [customerName] ]).

td1 :-
	branchFDS(FDS),
	bcnf(FDS, BCNF),
	check('branch decomposition', isbcnf(FDS, BCNF)).


td2 :-
	abcFDS(FDS),
	bcnf(FDS, BCNF),
	check('abcdef decomposition', isbcnf(FDS, BCNF)).

td3 :-
	supplierFDS(FDS),
	bcnf(FDS, BCNF),
	check('supplier decomposition', isbcnf(FDS, BCNF)).

td4 :-
	zipFDS(FDS),
	bcnf(FDS, BCNF),
	check('zip decomposition', isbcnf(FDS, BCNF)).

testDecomp :-
	td1,
	td2,
	td3,
	td4.

% ==================================================
% === Sets =========================================

in(X, [X|_]).
in(X, [_|S]) :- in(X, S).

subset([],_).
subset([X|S1],S2) :-
	in(X,S2),
	subset(S1,S2).

equal(X,Y) :-
	subset(X,Y), subset(Y,X).

rem(_,[],[]) .
rem(X,[X|S],R) :- rem(X,S,R), !.
rem(X,[Y|S],[Y|R]) :- rem(X,S,R) .

/* NB: Same as:
rem(_,[],[]) .
rem(X,[X|S],R) :- rem(X,S,R).
rem(X,[Y|S],[Y|R]) :- not(X = Y), rem(X,S,R) .
*/

union([],S,S) .
union([X|S1],S2,U) :-
	rem(X,S2,S),
	union(S1,[X|S],U).

diff(S,[],S).
diff(S1,[X|S2],D) :-
	rem(X,S1,S),
	diff(S,S2,D).

inter([],_,[]) .
inter([X|S1],S2,[X|I]) :-	in(X,S2), !,
				inter(S1,S2,I).
inter([_|S1],S2,I) :-		inter(S1,S2,I).

% --------------------------------------------------

testSets :-
	TestSet = [a,b,c,d,e],
	check('in(b,TestSet)', in(b,TestSet)),
	in(X,TestSet), check(subset, subset([X], TestSet)),
	check(equal1, equal(TestSet, TestSet)),
	check(equal2, equal(TestSet, [e,d,a,b,c])),
	union(TestSet, TestSet, U), check(union, equal(TestSet, U)).

% More ...

% ==================================================

check(_, Goal) :-
	% writeln(['Testing ', Name, '...']),
	Goal, !.
check(Name, _) :-
	writeln([Name, ' FAILED']).

writeln([]) :- nl.
writeln([X|L]) :- write(X), writeln(L).


not(X) :- X, !, fail.
not(_).


mydebug(L) :- verbose, !, writeln(L).
mydebug(_).

setverbose :-
	clearverbose, assert(verbose).
clearverbose :-
	retract(verbose), clearverbose.
clearverbose.

% ==================================================
% === tests ========================================

test :-
	clearverbose,
	% setverbose,
	testSets,
	testClosures,
	testKeys,
	testBCNF,
	testDecomp.

% ==================================================
