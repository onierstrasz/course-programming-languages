:- begin_tests(ex1).

test(grandfather1) :- grandfather(harry, philip).
test(grandfather2) :- \+ grandfather(harry, elizabeth).
test(grandfather3) :- \+ grandfather(harry, harry).
test(grandfather4) :- \+ grandfather(philip, harry).

test(grandmother1) :- \+ grandmother(harry, philip).
test(grandmother2) :- grandmother(harry, elizabeth).
test(grandmother3) :- \+ grandmother(harry, harry).
test(grandmother4) :- \+ grandmother(philip, harry).

test(grandparent1) :- grandparent(harry, philip).
test(grandparent2) :- grandparent(harry, elizabeth).
test(grandparent3) :- \+ grandparent(harry, harry).
test(grandparent4) :- \+ grandparent(philip, harry).

test(son1) :- \+ son(philip, harry).
test(son2) :- son(diana, harry).
test(son3) :- \+ son(harry, harry).
test(son4) :- \+ son(harry, diana).
test(son5) :- son(charles, harry).

test(daughter1) :- daughter(philip, anne).
test(daughter2) :- \+ daughter(harry, diana).
test(daughter3) :- \+ daughter(anne, anne).
test(daughter4) :- \+ daughter(anne, elizabeth).
test(daughter5) :- daughter(elizabeth, anne).

test(child1) :- \+ child(anne, philip).
test(child2) :- \+ child(harry, diana).
test(child3) :- \+ child(anne, anne).
test(child4) :- child(elizabeth, anne).
test(child5) :- child(charles, harry).

test(grandson1) :- grandson(philip, harry).
test(grandson2) :- \+ grandson(harry, diana).
test(grandson3) :- \+ grandson(william, elizabeth).
test(grandson4) :- grandson(elizabeth, william).
test(grandson5) :- \+ grandson(harry, philip).

test(granddaughter1) :- \+ granddaughter(philip, harry).
test(granddaughter2) :- \+ granddaughter(harry, diana).
test(granddaughter3) :- \+ granddaughter(william, elizabeth).
test(granddaughter4) :- \+ granddaughter(elizabeth, charlotte).
test(granddaughter5) :- granddaughter(diana, charlotte).

test(grandchild1) :- grandchild(philip, harry).
test(grandchild2) :- \+ grandchild(harry, diana).
test(grandchild3) :- \+ grandchild(william, elizabeth).
test(grandchild4) :- \+ grandchild(elizabeth, charlotte).
test(grandchild5) :- grandchild(diana, charlotte).

:- end_tests(ex1).