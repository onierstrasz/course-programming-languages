
% -----------------------------------------------------

not(X) :- X, !, fail.
not(_).

% -----------------------------------------------------

fact(0,1).
fact(N,F) :-
	N > 0,
	N1 is N - 1,
	fact(N1,F1),
	F is N * F1.

% ===== LISTS AND SETS ================================

/*
	in(X,L)			-- X is in list L
	append(L1,L2,L3) -- L1 append L2 yields L3
	rem(X,S,R)		-- list (set) R is S with X removed.
	diff(L1,L2,D)	-- list D is L1 minus L2
	union(L1,L2,U)	-- list U is L1 union L2
	inter(L1,L2,I)	-- list I is L1 intersection L2
*/

in(X, [X|_]).
in(X, [_|L]) :-				in(X, L).

/*
	in(a, [a,b,c]).
	in(X, [a,b,c]).
	in(a, L).
	L = [a|_A] ? ;
	L = [_A,a|_B] ? ;
	L = [_A,_B,a|_C] ? ;
	L = [_A,_B,_C,a|_D] ? ;
*/

% -----------------------------------------------------

append([],L,L).
append([X|L1],L2,[X|L3]) :-		append(L1,L2,L3) .

% -----------------------------------------------------

rem(_,[],[]) .
rem(X,[X|S],R) :-
	rem(X,S,R), !.
rem(X,[Y|S],[Y|R]) :-
	rem(X,S,R) .

% -----------------------------------------------------

diff(L,[],L).
diff(L1,[X|L2],D) :-
	rem(X,L1,L),
	diff(L,L2,D).

% -----------------------------------------------------

union([],L,L) .
union([X|L1],L2,U) :-
	rem(X,L2,L),
	union(L1,[X|L],U) .

% -----------------------------------------------------

/* not used:
inter([],L,[]) .
inter([X|L1],L2,[X|I]) :-
	in(X,L2), !,
	inter(L1,L2,I).
inter([X|L1],L2,I) :-
	inter(L1,L2,I).
*/

% =====================================================

perm([],[]).
perm([C|S1],S2) :-
	perm(S1,P1),
	append(X,Y,P1),
	append(X,[C|Y],S2).

% listall(perm([a,b,c,d],_)).

ndsort(L,S) :- perm(L,S), issorted(S).

issorted([]).
issorted([_]).
issorted([N,M|S]) :- N =< M, issorted([M|S]).

% ndsort([1, 2, 4, 3, 5], S).

% =====================================================
