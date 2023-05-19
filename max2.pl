:- compile(randms).

:- set_flag(print_depth, 1000).
:- lib(ic).
:- lib(branch_and_bound).

maxsat(NV, NC, D, F, S, M) :-
    create_formula(NV, NC, D, F), !,
    length(S, NV),
    S #:: 0..1,
    calculate(F, S, [], Clauses),
    Cost #= sum(Clauses),
    bb_min(search(S, 0, occurrence, indomain, complete, []), Cost, bb_options{strategy:dichotomic}),
    M #= NC-Cost.

get_cost([], 0).
get_cost([Var|S], Cost):- % Var == Clause
    Cost #= (Var #= 0) + Cost2,
    get_cost(S, Cost2).

calculate([], _, M, M).
calculate([H|T], S, SM, M):-
    get_cost(H, S1),
    append(SM, [neg(S1)], SM1),
    calculate(T, S, SM1, M).
    % calculate_inner_sum(H, S, 0, S1),
    % S #= (S1 #= 0),
    % calculate(T, S, [SM|S1], M).

calculate_inner_sum([], _, TS, TS).
calculate_inner_sum([H|T], S, SS, TS):-
    (H #< 0 ->
    Y #= H*(-1),
    get_ith(Y, S, E),
    SS1 #= eval(eval(neg E) or SS) ;
    get_ith(H, S, E),
    SS1 #= eval(E or SS)),
    calculate_inner_sum(T, S, SS1, TS).

get_ith(1, [H|_], H):- !.
get_ith(I, [_|T], E):-
  I1 is I - 1,
  get_ith(I1, T, E).