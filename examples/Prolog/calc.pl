
% ==================================================

/*
	Calculator interpreter
	(c) Oscar Nierstrasz, 2002

	To load from ciao, use:
	use_module(calc, [lex/2, parse/2, eval/2, test/0]).
*/

/*	Schmidt's calculator langauge
	p ::= ON s
	s ::= e TOTAL s | e TOTAL OFF
	e ::= e1 + e2 | e1 * e2 | if e1 , e2 , e3
		| LASTANSWER | ( e )
*/

:- module(calc, [lex/2, parse/2, eval/2, test/0]).

:- use_package(dcg).
:- use_module(library(strings), [whitespace0/2]).
:- use_module(library(terms), [atom_concat/2]).


% ==================================================
% ===== SCANNING ===================================

lex(Atom, Tokens) :-
	name(Atom, String),
	scan(Tokens, String, []), !.

scan([T|Tokens]) --> whitespace0, token(T), scan(Tokens).
scan([]) --> whitespace0.

token(on)    --> "ON".
token(total) --> "TOTAL".
token(off)   --> "OFF".
token(if)    --> "IF".
token(last)  --> "LASTANSWER".
token(',')   --> ",".
token('+')   --> "+".
token('*')   --> "*".
token('(')   --> "(".
token(')')   --> ")".

token(num(N)) --> digits(DL), { asnum(DL, N, 0) }.
digits([D|L]) --> digit(D), digits(L).
digits([D])   --> digit(D).
digit(D)      --> [D], { "0" =< D, D =< "9" }. 

asnum([D|DL], N, K) :-
	KD is 10*K + (D - "0"),
	asnum(DL, N, KD).
asnum("", N, N).

% ==================================================
% ===== PARSING ====================================

/*	Schmidt's calculator langauge
	p ::=	ON s
	s ::=	e TOTAL s
		|	e TOTAL OFF
	e ::=	if e1 , e1 , e1
		|	e1
	e1 ::=	e2 + e1
		|	e2
	e2 ::=	e3 * e2
		|	e3
	e3 ::=	LASTANSWER
		|	num
		|	( e0 )
*/

parse(Atom, Tree) :-
	lex(Atom, Tokens),
	prog(Tree, Tokens, []).

prog(S) --> [on], stmt(S).
stmt([E|S]) --> expr(E), [total], stmt(S).
stmt([E]) --> expr(E), [total, off].

expr(E) --> e0(E).

e0(if(Bool, Then, Else)) -->
	[if], e1(Bool), [','], e1(Then), [','], e1(Else).
e0(E) --> e1(E).

e1(plus(E1,E2)) --> e2(E1), ['+'], e1(E2).
e1(E) --> e2(E).

e2(times(E1,E2)) --> e3(E1), ['*'], e2(E2).
e2(E) --> e3(E).

e3(last) --> [last].
e3(num(N)) --> [num(N)].
e3(E) --> ['('], e0(E), [')'].

% ----- TESTS --------------------------------------

parseTests :-
	check(parse('ON 0 TOTAL OFF', [num(0)])),
	check(parse('ON 5 + 7 TOTAL OFF', [plus(num(5),num(7))])),
	check(parse('ON 4 * ( 3 + 2 ) TOTAL OFF',
		[times(num(4),plus(num(3),num(2)))])),
	check(parse(
		'ON (1+2)*(3+4) TOTAL LASTANSWER + 10 TOTAL OFF',
		[times(plus(num(1),num(2)),
			plus(num(3),num(4))),plus(last,num(10))])),
	check(parse(
		'ON IF LASTANSWER,1,2 TOTAL IF LASTANSWER,3,4 TOTAL OFF',
		[if(last,num(1),num(2)),if(last,num(3),num(4))])).

% ==================================================
% ===== SEMANTICS ==================================

eval(Expr, Val) :-
	parse(Expr, Tree),
	peval(Tree, Val).

peval(S,L) :-
	seval(S, 0, L).

seval([E], Prev, [Val]) :-
	xeval(E, Prev, Val).

seval([E|S], Prev, [Val|L]) :-
	xeval(E, Prev, Val),
	seval(S, Val, L).

xeval(num(N), _, N).
xeval(plus(E1,E2), Prev, V) :-
	xeval(E1, Prev, V1),
	xeval(E2, Prev, V2),
	V is V1+V2.

xeval(times(E1,E2), Prev, V) :-
	xeval(E1, Prev, V1),
	xeval(E2, Prev, V2),
	V is V1*V2.

xeval(last, Prev, Prev).

xeval(if(E1,E2,_), Prev, Val) :-
	xeval(E1, Prev, 0),
	xeval(E2, Prev, Val).

xeval(if(E1, _, E3), Prev, Val) :-
	xeval(E1, Prev, V1), V1 =\= 0,
	xeval(E3, Prev, Val).

% ----- TESTS --------------------------------------

showEval(E) :-
	write(E), write(' -> '),
	eval(E, V),	
	write(V), nl.

evalTests :-
	check(eval('ON 0 TOTAL OFF', [0])),
	check(eval('ON 5 + 7 TOTAL OFF', [12])),
	check(eval('ON 4 * ( 3 + 2 ) TOTAL OFF', [20])),
	check(eval(
		'ON (1+2)*(3+4) TOTAL LASTANSWER + 10 TOTAL OFF',
		[21, 31])),
	check(eval(
		'ON IF LASTANSWER,1,2 TOTAL IF LASTANSWER,3,4 TOTAL OFF',
		[1,4])).

% ==================================================
% ===== TESTS ======================================

test :-
	parseTests,
	evalTests,
	write('PASSED calc tests'), nl.

check(Goal) :- Goal, !.
check(Goal) :-
	write('TEST FAILED: '),
	write(Goal), nl.

% ==================================================
