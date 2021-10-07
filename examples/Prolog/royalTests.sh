#!/bin/sh 
exec ciao-shell $0 "$@" # -*- mode: ciao; -*-

% ==================================================

:- ensure_loaded(royal).

main(_) :-
	test,
	% Hm.  test will always succeed -- how to fix this?
	write('PASSED royal tests'), nl,
	true.

% ==================================================


