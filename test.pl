:- compile(randms).

:- set_flag(print_depth, 1000).
:- lib(ic).
:- lib(branch_and_bound).

% maxsat(NV, NC, D, F, S, M) :-
%     create_formula(NV, NC, D, F),
%     length(S, NV),
%     S #:: 0..1,
%     calculate(F, S, [], Clauses),
%     Cost #= sum(Clauses),
%     bb_min(search(S, 0, most_constrained, indomain, complete, []), Cost, bb_options{strategy:continue}),
%     M #= NC-Cost.
maxsat(NV, NC, D, F, S, M) :-
    create_formula(NV, NC, D, F),
    length(S,NV),
    S #:: 0..1,
    calculate(F, S, [], Clauses),
    Cost #= sum(Clauses),
    write("Cost before: "),
    writeln(Cost),
    bb_min(search(S, 0, most_constrained, indomain, complete, []), Cost, bb_options{strategy:continue}),
    writeln(Clauses),
    write("Cost after: "),
    writeln(Cost),
    M #= NC-Cost.

calculate([], _, M, M).
calculate([H|T], S, SM, M):-
    calculate_inner_sum(H, S, 0, S1),
    append(SM, [S1], SM1),
    % SM1 #= eval(SM + S1),
    calculate(T, S, SM1, M).

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