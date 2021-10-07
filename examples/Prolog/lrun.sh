#!/bin/sh 
exec ciao-shell $0 "$@" # -*- mode: ciao; -*-

% ==================================================

/*
	Lambda -- lambda calculus interpreter
	(c) Oscar Nierstrasz, 2002
*/

:- use_module(lambda, [lex/2, parse/2, verbose/2, eval/1, test/0]).

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
		verbose(Arg, ParenArg),
		write(ParenArg), nl, nl,
*/
    eval(Arg),
    doForEach(Args).

% ==================================================
