/* Notes:
 *
 *      1. The predicate hiden_skyscr is responsible for constraining the visible skyscrapers but also for ensuring different numbers in each row and column. 
 *
 *      2. With the help of the predicate get_transpose I transpose the table I use for the constraints of the visible from top to bottom. Finally, for the restrictions 
 *         of the visible from the right and from below, I reverse the list of objects to be treated in the same way as for the restrictions from the left and from above.
 *
 *      3. Unfortunately, for this particular problem an implementation with go_all was not possible because most combinations did not finish in a reasonable time, which 
 *         resulted in me having to manually stop the program several times. After several tests, I found the most effective combination to be the 
 *         Select: most_constrained Choice: indomain.
 */
:- lib(gfd).

skyscr(PuzzleId, Solution):-
    puzzle(PuzzleId, D, Left, Right, Up, Down, Board),
    create_board(D, D, [], Solution),
    hiden_skyscr(Solution, Board, D, Left, Right, Up, Down),
    flatten(Solution, Flatten_Solution),
    search(Flatten_Solution, 0, most_constrained, indomain_split, complete, []), !.

create_board(0, _, Solution, Solution):- !.
create_board(I, D, SoFar, Solution):-
    length(L, D),
    L :: 1..D,
    append(SoFar, [L], NewSoFar),
    I1 is I-1,
    create_board(I1, D, NewSoFar, Solution).

hiden_skyscr(Solution, Board, D, Left, Right, Up, Down):-
    alldifferent_lists(Solution),
    get_transpose(I, D, Solution, [], Transposed),
    alldifferent_lists(Transposed),
    Solution = Board,
    check_hiden(Left, Solution),
    reverse_list(Solution, [], RevRight),
    check_hiden(Right, RevRight),
    check_hiden(Up, Transposed),
    reverse_list(Transposed, [], RevTransposed),
    check_hiden(Down, RevTransposed).

alldifferent_lists([]).
alldifferent_lists([H|T]):-
    alldifferent(H),
    alldifferent_lists(T).

check_hiden([], []).
check_hiden([Number|RestNumbers], [List|RestLists]):-
    (Number > 0 ->
    make_max_list(List, [], [], MaxList),
    nvalues(MaxList, (#=), N),
    N #= Number ; true ),
    check_hiden(RestNumbers, RestLists).

make_max_list([], _, MaxList, MaxList).
make_max_list([H|T], SoFar, MaxSoFar, MaxList):-
    append(SoFar, [H], NewSoFar),
    MAX #= max(NewSoFar),
    append(MaxSoFar, [MAX], NewMaxSoFar),
    make_max_list(T, NewSoFar, NewMaxSoFar, MaxList).

reverse_list([], Reversed, Reversed).
reverse_list([H|T], SoFar, Reversed):-
    reverse(H, RH),
    append(SoFar, [RH], NewSoFar),
    reverse_list(T, NewSoFar, Reversed).

get_transpose(D, D, _, Transposed, Transposed).
get_transpose(I, D, Solution, SoFar, Transposed):-
    I1 #= I+1,
    get_elements(I1, Solution, [], L),
    append(SoFar, [L], NewSoFar),
    get_transpose(I1, D, Solution, NewSoFar, Transposed).

get_elements(_, [], R, R):- !.    
get_elements(I, [H|T], SoFar, R):-
    get_ith(I, H, E),
    append(SoFar, [E], NewSoFar),
    get_elements(I, T, NewSoFar, R).

get_ith(1, [H|_], H):- !.
get_ith(I, [_|T], E):-
  I1 is I - 1,
  get_ith(I1, T, E).