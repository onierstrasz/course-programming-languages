% ==================================================

/*
	Lambda -- lambda calculus interpreter
	Ciao-prolog module
	(c) Oscar Nierstrasz, 2002
	
	To load from ciao, use:
	use_module(lambda, [lex/2, parse/2, verbose/2, eval/1, test/0]).
*/

:- module(lambda, [lex/2, parse/2, verbose/2, eval/1, test/0]).

:- use_package(dcg).
:- use_module(library(strings), [whitespace0/2]).
:- use_module(library(terms), [atom_concat/2]).

% ==================================================
% ===== SCANNING ===================================

lex(Atom, Tokens) :-
	name(Atom, String),
	scan(Tokens, String, []), !.

scan([T|Tokens]) --> whitespace0, token(T), scan(Tokens).
scan([]) --> whitespace0.

token('(')  --> "(".
token(')')  --> ")".
token('\\') --> "\\".
token('.')  --> ".".

token(name(T)) --> ident(N), { name(T, N) }.

ident([X|N]) --> alpha(X), ident(N).
ident([X]) --> alpha(X).
alpha(X) --> [X], { isAlpha(X) }.

isAlpha(X) :- "a" =< X, X =< "z".
isAlpha(X) :- "A" =< X, X =< "Z".

% ==================================================
% ===== PARSING ====================================

/*
	E ::=	\x.E
		|	e1
	e1 ::=	e1 e2
		|	e2
	e2 ::=	x
		|	(E)
*/

parse(Atom, Tree) :-
	lex(Atom, Tokens),
	expr(Tree, Tokens, []).

expr(E) --> e0(E).

e0(lambda(X,E)) --> ['\\'], [name(X)], ['.'], e0(E).
e0(E) --> e1(E).

% NB: Left recursion pattern
e1(Apply) --> e2(E), applyTail(E, Apply).
applyTail(E, Apply) --> { E = Apply }.
applyTail(E, Apply) --> e0(F), applyTail(apply(E,F), Apply).

e2(name(X)) --> [name(X)].
e2(E) --> ['('], expr(E), [')'].

% ----- TESTS --------------------------------------

parseTests :-
	check(parse(x, name(x))),
	check(parse('x x', apply(name(x), name(x)))),
	check(parse('\\x.x', lambda(x, name(x)))),
	check(parse('\\x.x \\x.x', lambda(x,apply(name(x),lambda(x,name(x)))))),
	check(parse('\\x.\\x.x x', lambda(x,lambda(x,apply(name(x),name(x)))))).

% ==================================================
% ===== OUTPUT =====================================

% Add all possible parens:
verbose(Expr, Verbose) :-
	parse(Expr, Tree),
	addParens(Tree, Verbose).

addParens(err, 'err').
addParens(name(X), X).

addParens(apply(E, F), Apply) :-
	addParens(E, EA),
	addParens(F, FA),
	atom_concat(['(', EA, ' ', FA, ')'], Apply).

addParens(lambda(X, F), Lambda) :-
	addParens(F, FA),
	atom_concat(['(\\', X, '.', FA, ')'], Lambda).

% Check if addParens is sound:
idemVerbose(Atom) :-
	parse(Atom, Tree),
	addParens(Tree, Atom2),
	parse(Atom2, Tree2), !,
	Tree = Tree2.

% ----- TESTS --------------------------------------

verboseTests :-
	check(idemVerbose('a b c')),
	check(idemVerbose('\\x.x')),
	check(idemVerbose('\\x.x x')),
	check(idemVerbose('(\\x.x x) x')),
	check(idemVerbose('x \\x.x')).

% ----- PRETTY -------------------------------------

% Add all possible parens:
pretty(Expr, Pretty) :-
	parse(Expr, Tree),
	unParse(Tree, Pretty).

precedence(lambda,0).
precedence(apply,1).
precedence(name,2).

parenUnParse(Prec, E, PEA) :-
	unParse(E, EA),
	E =.. [Op|_],
	precedence(Op, N),
	( N >= Prec, PEA = EA
	; atom_concat(['(', EA, ')'], PEA)
	).

unParse(lambda(X, F), Lambda) :-
	parenUnParse(0, F, FA),
	atom_concat(['\\', X, '.', FA], Lambda).

% left assoc
unParse(apply(E, F), Apply) :-
	parenUnParse(1, E, EA),
	parenUnParse(2, F, FA),
	atom_concat([EA, ' ', FA], Apply).

unParse(name(X), X).

% Check if unParse is sound:
idemParse(Atom) :-
	parse(Atom, Tree),
	unParse(Tree, Atom2),
	parse(Atom2, Tree2), !,
	Tree = Tree2.

% ----- TESTS --------------------------------------

prettyTests :-
	check(idemParse('a b c')),
	check(idemParse('\\x.x')),
	check(idemParse('\\x.x x')),
	check(idemParse('(\\x.x x) x')),
	check(idemParse('x \\x.x')).

% ==================================================
% ===== SEMANTICS ==================================

% NB: No alpha rule!

eval(Expr) :-
	parse(Expr, Tree), !,
	% addParens(Tree, T), write(T), nl,
	unParse(Tree, T), write(T), nl,
	showSteps(Tree, _).

showSteps(Tree1, End) :-
	red(Tree1, Tree2), !,
		% write(Tree1), write(' -> '), write(Tree2), nl,
		% unParse(Tree1, T1), write(T1),
		write(' -> '),
		% nl, write(Tree2), nl,
		unParse(Tree2, T2), write(T2),
		nl,
	showSteps(Tree2, End).

showSteps(End, End) :-
	write('END'), nl.
	% unParse(End, PT), write(PT), nl.

% beta reduce
red(apply(lambda(X,Body), E), SBody) :-
	subst(X, E, Body, SBody).

% eta reduce
red(lambda(X, apply(F, name(X))), F) :-
	fv(F, Free),
	not(in(X, Free)).

% reduce LHS
red(apply(LHS, RHS), apply(F,RHS)) :-
	red(LHS, F).

/*
% reduce RHS (strict)
red(apply(LHS, RHS), apply(LHS,E)) :-
	red(RHS, E).
*/

redAll(Tree, End) :-
	red(Tree, Next), !,
	% write('->'), write(Next), nl,
	redAll(Next, End).
redAll(End, End).

% Reduce to normal form
nf(Expr, NF) :-
	parse(Expr, Tree), !,
	redAll(Tree, End),
	unParse(End, NF).

% ----- TESTS --------------------------------------

nfTests :-
	check(nf('(\\x.x) y', y)), % id
	check(nf('\\x.f x', f)), % eta
	check(nf('(\\x.x) (\\x.x)', '\\x.x')), % id id
	check(nf('(\\x.\\y.yx) y', '\\y\'.yx')), % name capture
	check(nf('(\\x.\\y.x y)  y', y)), % beta/eta/names
	check(nf('(\\x.y) ((\\x.x x) (\\x.x x))', y)), % lazy eval
	check(nf('(\\true.\\false.true false true) \
				(\\x.\\y.x) (\\x.\\y.y)',
			'\\x.\\y.y')),
	check(nf('(\\true.\\false. (\\not.(not true))	\
				(\\b.b false true))				\
				(\\x.\\y.x)						\
				(\\x.\\y.y)',
			'\\x.\\y.y')),

	true.

% ==================================================
% ===== SUBSTITUTION ===============================

subst(X, E, name(X), E).
subst(X, _, name(Z), name(Z)) :- X \= Z.
subst(X, E, apply(F, G), apply(SF, SG)) :-
	subst(X, E, F, SF),
	subst(X, E, G, SG).
subst(X, _, lambda(X, F), lambda(X, F)).
subst(X, E, lambda(Y, F), lambda(Y, SF)) :-
	X \= Y,
	fv(E, Free),
	not(in(Y, Free)),
	subst(X, E, F, SF).
subst(X, E, lambda(Y, F), lambda(Z, SF)) :-
	X \= Y,
	fv(E, Free),
	in(Y, Free),
	fv(F, FreeF),
	union(Free, FreeF, U),
	newname(Y, Z, U),
	subst(Y, name(Z), F, FZ),
	subst(X, E, FZ, SF).

not(X) :- X, !, fail.
not(_).

% ----- TESTS --------------------------------------

subTests :-
	check(subst(x, name(e), name(x), name(e))),
	check(subst(x, name(e), name(z), name(z))),
	check(subst(x, name(e), apply(name(x), name(x)), apply(name(e), name(e)))),
	check(subst(x, name(e), lambda(x, name(f)), lambda(x, name(f)))),
	check(subst(x, name(e), lambda(y, name(x)), lambda(y, name(e)))),
	check(subst(x, name(y), lambda(y, name(x)), lambda(Y, name(y)))),
	check(Y \= y),
	% subst(x, name(y), lambda(y, name(x)), Z), write(Z), nl,

	check(subst(x, name(y), lambda(y,apply(name(x),name(y))), 
		lambda(Z,apply(name(y),name(Z)))
		)),
	check(Z \= y).

% --------------------------------------------------

/*
	fv(E, F) -- F is the list of free variables in E

	fv(x) = { x }
	fv(e1 e2) = fv(e1) U fv(e2)
	fv(\x.e) = fv(e) - { x }
*/

fv(name(X), [X]).

fv(apply(E1,E2), F12) :-
	fv(E1, F1),
	fv(E2, F2),
	union(F1, F2, F12).

fv(lambda(X,E), F) :-
	% isname(X),
	fv(E, FE),
	diff(FE, [X], F).

% ----- TESTS --------------------------------------

fvTests :-
	parse('\\x.x y', E),
		check(fv(E, [y])).

% ==================================================
% ===== SYMBOLS ====================================

/*
	newname(Y, Z, F) -- Z is a new name for Y, not in F
	tick(Y, Z) -- Z is Y with a "tick" (') appended
*/

newname(Y, Y, F) :-
	not(in(Y, F)), !.

newname(Y, Z, F) :-
	% in(Y, F),
	tick(Y, T),
	newname(T, Z, F).

tick(Y, Z) :-
	name(Y, LY),
	append(LY, [39], LZ),
	name(Z, LZ).

% ==================================================
% ===== LISTS AND SETS =============================

/*
	in(X,L)			-- X is in list L
	append(L1,L2,L3) -- L1 append L2 yields L3
	rem(X,S,R)		-- list (set) R is S with X removed.
	diff(L1,L2,D)	-- list D is L1 minus L2
	union(L1,L2,U)	-- list U is L1 union L2
	inter(L1,L2,I)	-- list I is L1 intersection L2
*/

in(X, [X|_]).
in(X, [_|L]) :-
	in(X, L).

append([],L,L).
append([X|L1],L2,[X|L3]) :-
	append(L1,L2,L3) .

rem(_,[],[]) .
rem(X,[X|S],R) :-
	rem(X,S,R), !.
rem(X,[Y|S],[Y|R]) :-
	rem(X,S,R) .

diff(L,[],L).
diff(L1,[X|L2],D) :-
	rem(X,L1,L),
	diff(L,L2,D).

union([],L,L) .
union([X|L1],L2,U) :-
	rem(X,L2,L),
	union(L1,[X|L],U) .

/* not used:
inter([],L,[]) .
inter([X|L1],L2,[X|I]) :-
	in(X,L2), !,
	inter(L1,L2,I).
inter([X|L1],L2,I) :-
	inter(L1,L2,I).
*/

% ==================================================
% ===== TESTS ======================================

test :-
	parseTests,
	verboseTests,
	prettyTests,
	fvTests,
	subTests,
	nfTests,
	write('PASSED lambda tests'), nl,
	true.

check(Goal) :- Goal, !.
check(Goal) :-
	write('TEST FAILED: '),
	write(Goal), nl.

% ==================================================
