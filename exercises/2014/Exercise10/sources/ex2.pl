% SERIE 9 - May 2008

% EX 2 - Genealogy
% ----------------------------------------------

female(anne).		
female(diana).		
female(elizabeth).	
					
male(andrew).
male(charles).
male(edward).
male(harry).
male(philip).
male(william).

parent(harry, diana).
parent(harry, charles).
parent(edward, philip).
parent(edward, elizabeth).
parent(charles, philip).
parent(charles, elizabeth).
parent(anne, philip).
parent(anne, elizabeth).
parent(andrew, philip).
parent(andrew, elizabeth).
parent(william, charles).
parent(william, diana).

mother(X, M) :- parent(X,M), female(M).
father(X, M) :- parent(X,M), male(M).
sibling(X, Y) :- mother(X, M), mother(Y, M), father(X, F), father(Y, F), X \== Y.
brother(X, B) :- sibling(X,B), male(B).
sister(X, S) :- sibling(X,S), female(S).
uncle(X, U) :- parent(X, P), brother(P, U).
aunt(X, A) :- parent(X, P), sister(P, A).

%isparent(C, P) :- mother(C, P).
%isparent(C, P) :- father(C, P).

isparent(C, P) :- father(C, P), !; mother(C, P).

% --- further relations

grandfather(X, G) :- parent(X, P), parent(P, G), male(G).

grandmother(X, G) :- parent(X, P), parent(P, G), female(G).

grandparent(X, G) :- grandfather(X, G).
grandparent(X, G) :- grandmother(X, G).

son(X, S) :- isparent(S, X), male(S).

daughter(X, D) :- isparent(D, X), female(D).

child(X, C) :- isparent(C, X).

grandson(X, S) :- grandparent(S, X), male(S).

granddaughter(X, D) :- grandparent(D, X), female(D).

grandchild(X, C) :- grandparent(C, X).

niece(X, N) :- aunt(N, X), female(N).
niece(X, N) :- uncle(N, X), female(N).

nephew(X, N) :- aunt(N, X), male(N).
nephew(X, N) :- uncle(N, X), male(N).

cousin(X, Y) :- isparent(X, P), isparent(Y, Q), sibling(P, Q).