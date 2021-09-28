% Given a queen (Col) and a row distance (RowDist), when does she not beat any other queen?

noHit(_,_,[]) :- !.
noHit(Col,RowDist,[A_queen_col|Other_queens]) :- !,
		Diag_hit_col1 is Col + RowDist, A_queen_col =\= Diag_hit_col1,
		Diag_hit_col2 is Col - RowDist, A_queen_col =\= Diag_hit_col2,
		RowDist1 is RowDist + 1,
		noHit(Col,RowDist1,Other_queens).

% A single queen position is always safe

safePosition([_]) :- !.

% A queen position is safe when a queen does not beat other queens
% and the positions of the other queens are also safe

safePosition([A_queen|Other_queens]) :- !,
	noHit(A_queen,1,Other_queens),
	safePosition(Other_queens).

permute([],[]).
permute([X|Y],Z) :- permute(Y,L), append(A,B,L), append(A,[X|B],Z).

% Check for each permutation of the layout whether it's safe

safeLayout(Layout,Layout1) :- permute(Layout,Layout1), safePosition(Layout1).

% Print all solutions

nQueens(Layout) :- safeLayout(Layout,L), print(L), nl, fail.
nQueens(_).