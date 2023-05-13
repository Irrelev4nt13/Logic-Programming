% `or` `and` in general logic operators
% eval the sum of c1 c2 c3 c4
% 
% 
:- compile(randms).

:- set_flag(print_depth, 1000).
:- lib(ic).
:- lib(branch_and_bound).

maxsat(NV, NC, D, F, S, M) :-
    create_formula(NV, NC, D, F),
    writeln(F),
    length(S, NV),
    S #:: 0..1,
    calculate(F, S, 0, M),
    Cost #= NC-M,
    bb_min(search(S, 0, first_fail, indomain_middle, complete, []), Cost, bb_options{strategy:restart}).

calculate([], _, M, M).
calculate([H|T], S, SM, M):-
    calculate_inner_sum(H, S, 0, S1),
    % (H = [] -> SM1 #= SM + 1 ;
    (S1 #= 1 -> SM1 #= SM+1 ; SM1 #= SM),
    calculate(T, S, SM1, M).


calculate_inner_sum([], _, TS, TS).
calculate_inner_sum([H|T], S, SS, TS):-
    (H #< 0 ->
    Y #= H*(-1),
    get_ith(Y, S, E),
    E1 #= eval(1-E),
    SS1 #= eval(E1 or SS) ;
    get_ith(H, S, E),
    SS1 #= eval(E or SS)),
    calculate_inner_sum(T, S, SS1, TS).
% calculate_inner_sum([H|T], S, SS, TS):-
%     H #> 0,
%     get_ith(H, S, E),
%     SS1 #= eval(E or SS),
%     calculate_inner_sum(T, S, SS1, TS).

get_ith(1, [H|_], H):- !.
get_ith(I, [_|T], E):-
  I1 is I - 1,
  get_ith(I1, T, E).









% maxsat(NV, NC, D, F, S, M) :-
%     create_formula(NV, NC, D, F),
%     writeln(F),
%     length(S, NV),
%     S #:: 0..1,
%     calculate(F, S, 0, M),
%     Cost #= NC-M,
%     bb_min(search(S, 0, first_fail, indomain_middle, complete, []), Cost, bb_options{strategy:restart}).
