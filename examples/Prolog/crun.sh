#!/bin/sh 
exec ciao-shell $0 "$@" # -*- mode: ciao; -*-

% ==================================================

/*
	Calculator interpreter
	(c) Oscar Nierstrasz, 2002
*/

/*	Schmidt's calculator langauge
	p ::= ON s
	s ::= e TOTAL s | e TOTAL OFF
	e ::= e1 + e2 | e1 * e2 | if e1 , e2 , e3
		| LASTANSWER | ( e )
*/

% ==================================================

:- use_module(calc, [lex/2, parse/2, eval/2, test/0]).

main([]) :-
	test.

main(Argv) :-
	doForEach(Argv).

doForEach([]).
doForEach([Arg|Args]) :- 
/*
    lex(Arg, Tokens),
    write(Tokens), nl,
    parse(Arg, Tree),
    write(Tree), nl,
*/
	write(Arg), nl,
    eval(Arg, Val),
    write(Val), nl,
    doForEach(Args).

% ==================================================


