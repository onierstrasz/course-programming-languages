#!/bin/sh 
exec ciao-shell $0 "$@" # -*- mode: ciao; -*-

% demonstrates that all these different expressions
% represent the same lists

thesame(A,B,C) :-
	A = B, B = C.

listTests:-
	thesame(
		'.'(a,[])					,
		[a|[]]						,
		[a]							),
	thesame(
		'.'(a,'.'(b,[]))			,
		[a|[b|[]]]					,
		[a,b]						),
	thesame(
		'.'(a,'.'(b,'.'(c,[])))		,
		[a|[b|[c|[]]]]				,
		[a,b,c]						),
	thesame(
		'.'(a,b)					,
		[a|b]						,
		[a|b]						),
	thesame(
		'.'(a,'.'(b,c))				,
		[a|[b|c]]					,
		[a,b|c]						).

main(_) :-
	listTests,
	write('PASSED listTests'), nl.
