evenNumber([]).
evenNumber([_|R]) :- \+ evenNumber(R).

lastElement([X],X).
lastElement([_|R],X) :- lastElement(R,X).

withoutLast([_],[]).
withoutLast([X|R], [X|Y]) :- withoutLast(R,Y).

isPalindrom([]).
isPalindrom([_]).
isPalindrom([X|R]) :- lastElement(R,X), withoutLast(R,RR), isPalindrom(RR).