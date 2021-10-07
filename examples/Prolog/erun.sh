#!/bin/sh 
exec ciao-shell $0 "$@" # -*- mode: ciao; -*-

% ==================================================

/*	Standard DCG example from ciao prolog doc.
*/

% ==================================================

:- use_module(expr, [eval/2, test/0]).

main([]) :-
	test.

main(Argv) :-
	doForEach(Argv).

doForEach([]).
doForEach([Arg|Args]) :- 
	write(Arg), write(' = '),
    eval(Arg, Val),
    write(Val), nl,
    doForEach(Args).

% ==================================================


