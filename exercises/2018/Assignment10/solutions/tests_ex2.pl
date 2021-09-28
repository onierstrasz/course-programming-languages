:- begin_tests(ex2).

test(evenNumber1) :- evenNumber([]).
test(evenNumber2) :- \+ evenNumber([1]).
test(evenNumber3) :- evenNumber([1,2]).
test(evenNumber4) :- \+ evenNumber([1,2,3]).

test(isPalindrom1) :- isPalindrom([]).
test(isPalindrom2) :- isPalindrom([1]).
test(isPalindrom3) :- \+ isPalindrom([1,2]).
test(isPalindrom4) :- isPalindrom([1,2,1]).

:- end_tests(ex2).