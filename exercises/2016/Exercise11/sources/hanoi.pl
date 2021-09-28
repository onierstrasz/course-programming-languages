%ensure_loaded(library(operators)).
%op(900, xfy, to).

hanoi(1,A,B,_,[A to B]). 
hanoi(N,A,B,C,S) :- 
	N > 1,
	N1 is N - 1,
	hanoi(N1, A,C,B, S1),
	append(S1, [A to B], S2),
	hanoi(N1, C,B,A, S3),
	append(S2, S3, S).