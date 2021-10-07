/*
	Prolog case study -- various attempts to solve the problem
	 SEND
	+MORE
	-----
	MONEY

	Oscar Nierstrasz 27.9.97
*/

showAnswer(A,B,C) :- writeln([A, ' + ', B, ' = ', C]).

writeln([]) :- nl.
writeln([X|L]) :- write(X), writeln(L).

not(X) :- X, !, fail.
not(_).

% ==================================================

% What we would like to write:

soln0 :-
	A is 1000*S + 100*E + 10*N + D,
	B is 1000*M + 100*O + 10*R + E,
	C is 10000*M + 1000*O + 100*N + 10*E + Y,
	C is A+B,
	showAnswer(A,B,C).

/* Doesn't work because "is" can only evaluate expressions
over instantaited variables.

soln0.

evaluation_error: [goal(_1007 is 1000*_1008+100*_1009+10*_1010+_1011),argument_index(2)]

[Execution aborted]
*/

% ==================================================

% So let's instantiate them:

digit(0).
digit(1).
digit(2).
digit(3).
digit(4).
digit(5).
digit(6).
digit(7).
digit(8).
digit(9).

digits([]).
digits([D|L]) :- digit(D), digits(L).

soln1 :-
	digits([S,E,N,D,M,O,R,E,M,O,N,E,Y]),
	A is 1000*S + 100*E + 10*N + D,
	B is 1000*M + 100*O + 10*R + E,
	C is 10000*M + 1000*O + 100*N + 10*E + Y,
	C is A+B,
	showAnswer(A,B,C).

/* Correct, but yields a trivial solution:
soln1.
0 + 0 = 0
yes
*/

% ==================================================

% So let's constrain S and M:

soln2 :-
	digits([S,M]),
	not(S==0), not(M==0),
	digits([S,E,N,D,M,O,R,E,M,O,N,E,Y]),
	A is 1000*S + 100*E + 10*N + D,
	B is 1000*M + 100*O + 10*R + E,
	C is 10000*M + 1000*O + 100*N + 10*E + Y,
	C is A+B,
	showAnswer(A,B,C).

/* Maybe it works ... we'll never know

soln2.

[Execution aborted]
after 8 minutes still running ...
*/

% ==================================================

% Let's try to exercise more control by instantiating
% variable bottom up:

sum([],0).
sum([N|L], TOTAL) :-
	sum(L,SUBTOTAL), TOTAL is N + SUBTOTAL.

% carrysum(L,D,C) :- sum(L,S), C is S/10, D is S - 10*C.

% need integer division for ciao
carrysum(L,D,C) :- sum(L,S), C is S//10, D is S - 10*C.

soln3 :-
	digits([D,E]), carrysum([D,E],Y,C1),
	digits([N,R]), carrysum([C1,N,R],E,C2),
	digit(O), carrysum([C2,E,O],N,C3),
	digits([S,M]), not(S==0), not(M==0),
	carrysum([C3,S,M],O,M),
	A is 1000*S + 100*E + 10*N + D,
	B is 1000*M + 100*O + 10*R + E,
	C is 10000*M + 1000*O + 100*N + 10*E + Y,
	C is A+B,
	showAnswer(A,B,C).

/* Correct, but uninteresting:
soln3.
9000 + 1000 = 10000
yes
*/

% ==================================================

% Let's try to make the variables unique:

unique([]).
unique([X|L]) :- not(in(X,L)), unique(L).

in(X, [X|_]).
in(X, [_|L]) :-			in(X, L).

soln4 :-
	L1 = [D,E], digits(L1), unique(L1),
	carrysum([D,E],Y,C1),
	L2 = [N,R,Y|L1], digits([N,R]), unique(L2),
	carrysum([C1,N,R],E,C2),
	L3 = [O|L2], digit(O), unique(L3),
	carrysum([C2,E,O],N,C3),
	L4 = [S,M|L3], digits([S,M]), not(S==0), not(M==0),
	unique(L4),
	carrysum([C3,S,M],O,M),
	A is 1000*S + 100*E + 10*N + D,
	B is 1000*M + 100*O + 10*R + E,
	C is A+B,
	showAnswer(A,B,C).

soln(A,B,C) :-
	L1 = [D,E], digits(L1), unique(L1),
	carrysum([D,E],Y,C1),
	L2 = [N,R,Y|L1], digits([N,R]), unique(L2),
	carrysum([C1,N,R],E,C2),
	L3 = [O|L2], digit(O), unique(L3),
	carrysum([C2,E,O],N,C3),
	L4 = [S,M|L3], digits([S,M]), not(S==0), not(M==0),
	unique(L4),
	carrysum([C3,S,M],O,M),
	A is 1000*S + 100*E + 10*N + D,
	B is 1000*M + 100*O + 10*R + E,
	C is A+B.

/* This works, in about 8 seconds on a PowerMac 7300/200:
soln4.
9567 + 1085 = 10652
yes

How would you check if the solution is unique?
How would you generalize this to solve arbitrary additions?
*/

% slower

soln5 :-
	L1 = [D,E], digits(L1), % unique(L1),
	carrysum([D,E],Y,C1),
	L2 = [N,R,Y|L1], digits([N,R]), % unique(L2),
	carrysum([C1,N,R],E,C2),
	L3 = [O|L2], digit(O), % unique(L3),
	carrysum([C2,E,O],N,C3),
	L4 = [S,M|L3], digits([S,M]), not(S==0), not(M==0),
	unique(L4),
	carrysum([C3,S,M],O,M),
	A is 1000*S + 100*E + 10*N + D,
	B is 1000*M + 100*O + 10*R + E,
	C is 10000*M + 1000*O + 100*N + 10*E + Y,
	% C is A+B,
	showAnswer(A,B,C).

% ==================================================
