
% In some Prologs it is necessary to declare that these predicates are dynamic, that is, they can still be modified after compilation.
% :- dynamic male/1, female/1, parent/2.

female(anne).
female(diana).
female(elizabeth).
male(andrew).
male(charles).
male(edward).
male(harry).
male(philip).
male(william).

parent(andrew, elizabeth).
parent(andrew, philip).
parent(anne, elizabeth).
parent(anne, philip).
parent(charles, elizabeth).
parent(charles, philip).
parent(edward, elizabeth).
parent(edward, philip).
parent(harry, charles).
parent(harry, diana).
parent(william, charles).
parent(william, diana).

% ------------------------------------------------------

mother(X, M) :-	parent(X,M),
	female(M).

father(X, M) :-
	parent(X,M),
	male(M).

sibling(X, Y) :-	mother(X, M), mother(Y, M),
	father(X, F), father(Y, F),
	X \== Y.

brother(X, B) :-	sibling(X,B), male(B).
uncle(X, U) :-
	parent(X, P),
	brother(P, U).

sister(X, S) :-	sibling(X,S), female(S).
aunt(X, A) :-	parent(X, P), sister(P, A).

isparent(C, P) :-	mother(C, P); father(C, P).

/* equivalently:
isparent(C, P) :-	mother(C, P).
isparent(C, P) :-	father(C, P).
*/

% ------------------------------------------------------

% recursion:
ancestor(X, A) :-	parent(X, A).
ancestor(X, A) :-
	parent(X, P),
	ancestor(P, A).

% incorrect recursion:

anc2(X, A) :-	anc2(P, A),
	parent(X, P).
anc2(X, A) :-	parent(X, A).

anc3(X, A) :- parent(X, A).
anc3(X, A) :- anc3(P, A), parent(X, P).

anc4(X, A) :- parent(X, P), anc4(P, A).
anc4(X, A) :- parent(X, A).

% ------------------------------------------------------

rename(X,Y) :-	retract(male(X)),
	assert(male(Y)),
	rename(X,Y).

rename(X,Y) :-	retract(female(X)),
	assert(female(Y)),
	rename(X,Y).

rename(X,Y) :-	retract(parent(X,P)),
	assert(parent(Y,P)),
	rename(X,Y).

rename(X,Y) :-	retract(parent(C,X)),
	assert(parent(C,Y)),
	rename(X,Y).

rename(_,_).

% ------------------------------------------------------

% fail:
printall(X) :-	X, print(X), nl, fail.
printall(_).
% printall(brother(_,_)).

royals :-	printall(male(_)),
	printall(female(_)),
	printall(parent(_,_)).

not(X) :-	X, !, fail.
not(_).

% ------------------------------------------------------

check(Goal) :-
	Goal, !.
check(Goal) :-
	functor(Goal,Name,Arity),
	write(Name), write('/'), write(Arity),
	write(' FAILED'), nl.

% Hm.  Should keep track of the number of failed tests.
test :-
	check(male(charles)),
	check(not(male(anne))),
	check(not(male(mickey))),
	check(male(_)),
	mother(charles, M), check(M == elizabeth),
	check(father(william, _)),
	check(mother(_, elizabeth)),
	check(not(mother(elizabeth, _))),
	check(uncle(harry, andrew)),
	check(ancestor(harry, philip)),
	true.

/*
% Royal queries

male(charles).
male(anne).
male(mickey).
male(X).

mother(charles, M).
father(william, _).

mother(X, elizabeth).

mother(elizabeth, M).

uncle(harry, U).

ancestor(harry, X).
ancestor(X, philip).
ancestor(harry, philip).

anc2(X, philip).
anc2(harry, X).

rename(charles, mickey).
parent(harry,P).

male(charles); parent(charles, _); parent(_, charles).

printall(male(_)).

*/
