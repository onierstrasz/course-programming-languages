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


digit(0). digit(1). digit(2). digit(3). digit(4).
digit(5). digit(6). digit(7). digit(8). digit(9).
digits([]).
digits([D|R]) :- digit(D), digits(R).

soln0 :- digits([S,E,N,D,M,O,R,E,M,O,N,E,Y]),
         not(S == 0),
         not(M == 0),
         A is 1000*S + 100*E + 10*N + D,
         B is 1000*M + 100*O + 10*R + E,
         C is 10000*M + 1000*O + 100*N + 10*E + Y,
         C is A+B,
         /* not(C == 0), */
         /* not(A == 0), */
         /* not(B == 0), */
         writeln([S,E,N,D]),
         writeln([M,O,R,E]),
         showAnswer(A,B,C).

showAnswer(A,B,C) :- writeln([A, ' + ', B, ' = ', C]).
writeln([])       :- nl.
writeln([X|L])    :- write(X), writeln(L).

sum([],0).
sum([N|R], TOTAL) :- sum(R, SUBTOTAL), TOTAL is SUBTOTAL + N.

:-ensure_loaded(library(operators)).
:-op(900, xfy, to).

hanoi(1,A,B,_,[A to B]). 


hanoi(N,A,B,C,S) :- 
    N > 1,
    N1 is N - 1,
    hanoi(N1, A,C,B, S1),
    append(S1, [A to B], S2),
    hanoi(N1, C,B,A, S3),
    append(S2, S3, S).
