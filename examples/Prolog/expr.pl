
% ==================================================

/*	Standard DCG example from ciao prolog doc.
	load as follows:
		use_module(expr).
	Try:
	expr(X,"5+2*3", []).
	expr(Z, "-2+3*5+1", []).
*/

:- module(expr, [eval/2, test/0, expr/3]).

:- use_package(dcg).
:- use_module(library(strings), [whitespace0/2]).
:- use_module(library(terms), [atom_concat/2]).

% ==================================================
% ===== EXPRESSIONS ================================

expr(Z) --> term(X), "+", expr(Y), {Z is X + Y}.
expr(Z) --> term(X), "-", expr(Y), {Z is X - Y}.
expr(X) --> term(X).

term(Z) --> number(X), "*", term(Y), {Z is X * Y}.
term(Z) --> number(X), "/", term(Y), {Z is X / Y}.
term(Z) --> number(Z).

number(C) --> "+", number(C).
number(C) --> "-", number(X), {C is -X}.
number(X) --> [C], {0'0=<C, C=<0'9, X is C - 0'0}.

eval(E, Val) :-
	name(E, String),
	expr(Val, String, []).

% ==================================================
% ===== TESTS ======================================

evalTests :-
	eval('1+2', 3),
	eval('-2+3*5+1', 14).

test :-
	evalTests,
	write('PASSED expr tests'), nl.

check(Goal) :- Goal, !.
check(Goal) :-
	write('TEST FAILED: '),
	write(Goal), nl.

% ==================================================
