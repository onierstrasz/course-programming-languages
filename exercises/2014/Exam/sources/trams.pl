% a) transport network database

connected(breitenrain,spitalacker,9). 
connected(breitenrain,spitalacker,40). 
connected(spitalacker,rosengarten,40). 
connected(spitalacker,breitenrain,9). 
connected(spitalacker,zytglogge,9). 
connected(zytglogge,baerenplatz,9). 
connected(zytglogge,baerenplatz,12). 
connected(zytglogge,baerenplatz,3). 
connected(zytglogge,baerenplatz,5). 
connected(zytglogge,spitalacker,9). 
connected(zytglogge,schosshalde,12). 
connected(zytglogge,brunnadernst,3). 
connected(zytglogge,brunnadernst,5). 
connected(baerenplatz,bahnhof,3). 
connected(baerenplatz,bahnhof,5). 
connected(baerenplatz,bahnhof,9). 
connected(baerenplatz,bahnhof,12). 
connected(bahnhof,baerenplatz,3). 
connected(bahnhof,baerenplatz,5). 
connected(bahnhof,baerenplatz,9). 
connected(bahnhof,baerenplatz,12). 
connected(brunnadernst,zytglogge,3). 
connected(brunnadernst,zytglogge,5). 
connected(brunnadernst,ostring,5). 
connected(brunnadernst,saali,3). 
connected(saali,brunnadernst,3). 
connected(ostring,brunnadernst,5). 
connected(ostring,schosshalde,40). 
connected(schosshalde,zytglogge,12). 
connected(schosshalde,rosengarten,40). 
connected(schosshalde,zentrumpaulklee,12). 
connected(schosshalde,ostring,40). 
connected(zentrumpaulklee,schosshalde,12). 
connected(rosengarten,schosshalde,40). 
connected(rosengarten,breitenrain,40).

% b)

reachable(X,Y) :- reachableVia(X,Y,[X]). 
reachableVia(X,Y,S) :- connected(X,Y,_), not(in(Y,S)). 
reachableVia(X,Y,S) :- connected(X,A,_), not(in(A,S)), reachableVia(A,Y,[A|S]).

% c)
	
reachableBy(X,Y,Z) :- reachableByVia(X,Y,Z,[X]). 
reachableByVia(X,Y,Z,S) :- connected(X,Y,Z), not(in(Y,S)). 
reachableByVia(X,Y,Z,S) :- connected(X,A,Z), not(in(A,S)), reachableByVia(A,Y,Z,[A|S]). 

in(X,[X|_]).
in(X,[_|L]):- in(X,L).
not(X):- (X -> fail); true.