
connection(A,B) :- line(A,B); line(B,A).
in(X,[X|_]).
in(X,[_|L]):- in(X,L).

line(a,b).
line(b,d).
line(c,a).
line(c,d).
line(c,e).
line(d,e).
line(f,g).
line(f,h).
line(g,j).
line(h,i).
line(i,j).


triangle(A,B,C) :- connection(A,B), connection(B,C), connection(C,A).


quadrangle(A,B,C,D) :- connection(A,B), connection(B,C), connection(C,D), connection(D,A), 
                       not(in(D,[A,B,C])).

reachable(X,Y) :- line(X,Y).
reachable(X,Y) :- line(X,Z), reachable(Z,Y).