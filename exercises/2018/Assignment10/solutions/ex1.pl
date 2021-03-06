female(anne).
female(diana).		
female(elizabeth).
female(kate).
female(charlotte).

					
male(andrew).		
male(charles).		
male(edward).		
male(harry).		
male(philip).		
male(william).
male(george).
male(loius).		
			
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
parent(george, william).
parent(george, kate).
parent(charlotte, william).
parent(charlotte, kate).
parent(louis, william).
parent(louis, kate).

mother(X, M) :- parent(X,M), female(M).
father(X, M) :- parent(X,M), male(M).

grandfather(X, G) :- parent(X, P), parent(P, G), male(G).
grandmother(X, G) :- parent(X, P), parent(P, G), female(G).
grandparent(X, G) :- grandfather(X, G).
grandparent(X, G) :- grandmother(X, G).

son(X, S) :- parent(S, X), male(S).
daughter(X, D) :- parent(D, X), female(D).
child(X, C) :- parent(C, X).

grandson(X, S) :- grandparent(S, X), male(S).
granddaughter(X, D) :- grandparent(D, X), female(D).
grandchild(X, C) :- grandparent(C, X).