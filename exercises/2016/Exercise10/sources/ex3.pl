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
