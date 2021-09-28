female(anne).
female(diana).
female(elizabeth).

male(andrew).
male(charles).
male(edward).
male(harry).
male(philip).
male(william).

parent(adnrew, elizabeth).
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

mother(X, M) :- parent(X, M), female(M).
father(X, F) :- parent(X, F), male(F).

ancestor(X, A) :- parent(X, A).
ancestor(X, A) :- parent(X, P), ancestor(P, A).

printall(X) :- X, print(X), nl, fail.
printall(_).

negate(X) :- X, !, fail.
negate(_).

in(X, [X | _]).
in(X, [_ | L]) :- in(X,L).



append([],L,L).
append([X|L1],L2,[X|L3]) :- append(L1,L2,L3).

oddNumber([_]).
oddNumber([_|R]) :- \+ oddNumber(R).

permutation([X], [X]).
permutation([X|R], L) :- permutation(R, Y), select(X, L, Y).


isMerged([],[],[]).
isMerged([X|R], L1, L2) :- isMerged(R, Y, L2), select(X, L1, Y).
isMerged([X|R], L1, L2) :- isMerged(R, L1, Y), select(X, L2, Y).

lastElement([X],X).
lastElement([_|R],X) :- lastElement(R,X).

withoutLast([_],[]).
withoutLast([X|R], [X|Y]) :- withoutLast(R,Y).

isPalindrom([]).
isPalindrom([_]).
isPalindrom([X|R]) :- lastElement(R,X), withoutLast(R,RR), isPalindrom(RR).
