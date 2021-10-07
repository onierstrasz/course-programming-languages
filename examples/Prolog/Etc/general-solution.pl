showAnswer(A,B,C) :- writeln([A, ' + ', B, ' = ', C]).

writeln([]) :- nl.
writeln([X|L]) :- write(X), writeln(L).

not(X) :- X, !, fail.
not(_).

digit(0).
digit(1).
digit(2).
digit(3).
digit(4).
digit(5).
digit(6).
digit(7).
digit(8).
digit(9).

digits([]).
digits([D|L]) :- digit(D), digits(L).

sum([],0).
sum([N|L], TOTAL) :-
	sum(L,SUBTOTAL), TOTAL is N + SUBTOTAL.

carrysum(L,D,C) :- sum(L,S), C is S//10, D is S - 10*C.

unique([]).
unique([X|L]) :- notin(X,L), unique(L).

in(X, [X|_]).
in(X, [_|L]) :-	in(X, L).

notin(X, []).
notin(X,[Y|Ys]) :- X\==Y, notin(X,Ys).

inCharList(A,[A|_],[C|_],D) :- D = C.
inCharList(A,[_|B],[_|C],D) :- inCharList(A,B,C,D).

notinCharList(A, []).
notinCharList(A, [B|Bs]) :- A\==B, notinCharList(A,Bs).

insert(eol,OCL,ODL,NCL,NDL,0) :- append(OCL,[],NCL), append(ODL,[],NDL).
insert(A,OCL,ODL,NCL,NDL,DA) :- A\==eol,inCharList(A,OCL,ODL,DA),
	append(OCL,[],NCL), append(ODL,[],NDL).
insert(A,OCL,ODL,NCL,NDL,DA) :- A\==eol,notinCharList(A,OCL), digit(DA),
	append([DA],ODL,NDL), unique(NDL), append([A],OCL,NCL),unique(NCL).

splitlast([],Y,Z) :- Y='eol', append([],[],Z).
splitlast(X,Y,Z) :- splitlasth(X,Y,Z,[]).

splitlasth([X],X,Z,H) :- append(H,[],Z).
splitlasth([X|Xs],Y,Z,H) :- append(H,[X],H0), splitlasth(Xs,Y,Z,H0).

first(X,[X|_]).

solve(A,B,C,DA,DB,DC) :- solveh(A,B,C,[],[],0,DA,DB,DC,CharList,DigitList),
	first(A1,A), first(B1,B),
	inCharList(A1,CharList,DigitList,DA1), not(DA1 == 0),
	inCharList(B1,CharList,DigitList,DB1), not(DB1 == 0).

% A,B,C lists of characters
% OCL old list of seen characters
% ODL old list of used digits
% DA,DB,DC digit value of A,B,C
% NCL new list of seen charactters
% NDL new list of used digits
% OCS old carry sum
solveh([],[],[],OCL,ODL,OCS,0,0,0,NCL,NDL) :- not(OCS == 0),fail.
solveh([],[],[],OCL,ODL,OCS,0,0,0,NCL,NDL) :- OCS == 0,
	append(OCL,[],NCL),append(ODL,[],NDL).
solveh(A,B,[],OCL,ODL,OCS,DA,DB,DC,NCL,NDL) :- !,fail.
solveh([],[],[C],OCL,ODL,OCS,0,0,OCS,NCL,NDL) :-
	not(OCS == 0),insert(C,OCL,ODL,NCL,NDL,OCS).
solveh([],[],C,OCL,ODL,OCS,NDA,NDB,NDC,NCL,NDL) :- !,fail.
solveh([],B,C,OCL,ODL,OCS,0,DB,DC,NCL,NDL) :-
	splitlast(B,LB,HB),splitlast(C,LC,HC),
	insert(LB,NCL1,NDL1,NCL2,NDL2,DLB),
	insert(LC,NCL2,NDL2,NCL3,NDL3,DLC),
	carrysum([DLB,OCS],DLC,NCS),
	solveh([],HB,HC,NCL3,NDL3,NCS,0,NDB,NDC,NCL,NDL),
	DB is 10*NDB + DLB,
	DC is DB.
solveh(A,[],C,OCL,ODL,OCS,DA,0,DC,NCL,NDL) :-
	splitlast(A,LA,HA),splitlast(C,LC,HC),
	insert(LA,OCL,ODL,NCL1,NDL1,DLA),
	insert(LC,NCL2,NDL2,NCL3,NDL3,DLC),
	carrysum([DLA,OCS],DLC,NCS),
	solveh(HA,[],HC,NCL3,NDL3,NCS,NDA,0,NDC,NCL,NDL),
	DA is 10*NDA + DLA,
	DC is DA.
solveh(A,B,C,OCL,ODL,OCS,DA,DB,DC,NCL,NDL) :-
	splitlast(A,LA,HA),splitlast(B,LB,HB),splitlast(C,LC,HC),
	insert(LA,OCL,ODL,NCL1,NDL1,DLA),
	insert(LB,NCL1,NDL1,NCL2,NDL2,DLB),
	insert(LC,NCL2,NDL2,NCL3,NDL3,DLC),
	carrysum([DLA,DLB,OCS],DLC,NCS),
	solveh(HA,HB,HC,NCL3,NDL3,NCS,NDA,NDB,NDC,NCL,NDL),
	DA is 10*NDA + DLA,
	DB is 10*NDB + DLB,
	DC is DA + DB.
	