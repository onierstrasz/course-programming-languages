#!/bin/sh 
exec ciao-shell $0 "$@" # -*- mode: ciao; -*-

% ==================================================

:- ensure_loaded(bcnf).

main(_) :-
	test,
	write('PASSED bcnf tests'), nl,
	true.

% ==================================================


