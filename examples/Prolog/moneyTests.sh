#!/bin/sh 
exec ciao-shell $0 "$@" # -*- mode: ciao; -*-

% ==================================================

:- ensure_loaded(money).

main(_) :-
	soln(9567,1085,10652),
	write('PASSED money tests'), nl,
	true.

% ==================================================


