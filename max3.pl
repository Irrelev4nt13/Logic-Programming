:- compile(randms).

:- set_flag(print_depth, 1000).
:- lib(ic).
:- lib(branch_and_bound).


maxsat(NV, NC, D, F, S, M) :-
    create_formula(NV, NC, D, F), !,
    length(S, NV),
    S #:: 0..1,
    calculate(F, S, Cost).
    % ,
    % bb_min(search(S, 0, occurrence, indomain, complete, []), Cost, bb_options{strategy:dichotomic}),
    % M #= NC-Cost.

calculate(F, S, Cost):-
    create_clauses(F, S, Clauses),
    % create_costlist(Clauses, Cost),
    writeln(Cost).
    % ,writeln(Clauses).
    calculate_cost(Clauses, 0, Cost).

create_clauses(F, S, Clauses):-
    create_clauses(F, S, [], Clauses).

create_clauses([], _, Clauses, Clauses).
create_clauses([H|T], S, SoFar, Clauses):-
    create_subclause(H, S, [], Clause),
    append(SoFar, [Clause], NewSoFar),
    create_clauses(T, S, NewSoFar, Clauses).

create_subclause([], _, Clause, Clause).
create_subclause([H|T], S, SoFar, Clause):-
    (H #< 0 ->
    Y #= H*(-1),
    get_ith(Y, S, C),
    C1 is 1-C,
    append(SoFar, [C1], NewSoFar) ;
    get_ith(H, S, C),
    append(SoFar, [C], NewSoFar)),
    create_subclause(T, S, NewSoFar, Clause).

% calculate_cost([], 0).
% calculate_cost([H|T], Cost):-
%     Cost #= (H #= 0) + Cost1,
%     calculate_cost(T, Cost1).
calculate_cost([], Acc, Acc).
calculate_cost([H|T], Acc, Cost) :-
    NewAcc #= (H #= 0) + Acc,
    calculate_cost(T, NewAcc, Cost).
% create_costlist([], []).
% create_costlist([Clause|Clauses], [S|Ss]):-
%     create_costlist(Clauses, Ss),
%     sumlist(Clause, C),
%     S #= (C #= 0).

% sumlist(L, S) :- sumlist(L, 0, S).
% sumlist([], S, S).
% sumlist([X|L], S1, S) :- S2 is X+S1, sumlist(L, S2, S). 
% calculate([], _, M, M).
% calculate([H|T], S, SM, M):-
%     calculate_inner_sum(H, S, 0, S1),
%     SM1 #= eval(SM + eval(neg(S1))),
%     calculate(T, S, SM1, M).

% calculate_inner_sum([], _, TS, TS).
% calculate_inner_sum([H|T], S, SS, TS):-
%     (H #< 0 ->
%     Y #= H*(-1),
%     get_ith(Y, S, E),
%     SS1 #= eval(eval(neg E) or SS) ;
%     get_ith(H, S, E),
%     SS1 #= eval(E or SS)),
%     calculate_inner_sum(T, S, SS1, TS).

get_ith(1, [H|_], H):- !.
get_ith(I, [_|T], E):-
  I1 is I - 1,
  get_ith(I1, T, E).
