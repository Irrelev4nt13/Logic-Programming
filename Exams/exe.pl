% ------------ Implementations With Cut (!) ------------ % 
my_intersection_1([], _, []).
my_intersection_1([X|L1], L2, [X|L3]) :-
    member(X, L2), !,
    my_intersection_1(L1, L2, L3).
my_intersection_1([_|L1], L2, L3) :-
    my_intersection_1(L1, L2, L3).














% ------------ Implementations Without Cut (!) ------------ % 

% The intersection of an empty list with a list is an empty list
my_intersection_2([], _, []).
% If the head of the first list is not in the second list then 
% Recurse without this element because it not a common element
my_intersection_2([X|L1], L2, L3) :-
    \+ member(X, L2),
    my_intersection_2(L1, L2, L3).
% If the head of the first list is in the second list then
% Make the third list with head that element and then keep recursing
my_intersection_2([X|L1], L2, [X|L3]) :-
    member(X, L2),
    my_intersection_2(L1, L2, L3).

% The union of an empty list with a list is the second list.
my_union_2([], L1, L1).
% If the head of the first list is in the second list then 
% Recurse without this element because it already exists
my_union_2([X|L1], L2, L3) :-
    member(X, L2),
    my_union_2(L1, L2, L3).
% If the head of the first list is not in the second list then
% Make the third list with head that element and then keep recursing
my_union_2([X|L1], L2, [X|L3]) :-
    \+ member(X, L2),
    my_union_2(L1, L2, L3).

% The difference of an empty list with a list is an empty list.
my_difference_2([], _, []).
% If the head of the first list is member of the second list then 
% Recurse without this element because it exists in both lists
my_difference_2([X|L1], L2, L3) :-
    member(X, L2),
    my_difference_2(L1, L2, L3).
% If the head of the first list is not in the second list then
% Make the third list with head that element and then keep recursing
my_difference_2([X|L1], L2, [X|L3]) :-
    \+ member(X, L2),
    my_difference_2(L1, L2, L3).