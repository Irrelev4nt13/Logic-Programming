:- compile(randms).

:- set_flag(print_depth, 1000).
:- lib(ic).
:- lib(branch_and_bound).

% maxsat(NV, NC, D, F, S, M) :-
%     create_formula(NV, NC, D, F), !,
%     length(S,NV),
%     S #:: 0..1,
%     calculate(F, S, 0, Cost),
%     % Cost #= sum(Cost1),
%     bb_min(search(S, 0, most_constrained, indomain, complete, []), Cost, bb_options{strategy:dichotomic}),
%     M #= NC-Cost.

% calculate([], _, C, C). % :-halt.
% calculate([H|T], S, SC, C):-
%     % (H = [] ->
%     % write("Clause = "),
%     % write(H),write(" "),
%     calculate_inner_sum(H, S, 0, S1),
%     % write("Domain = "),
%     % writeln(S1),
%     (   S1 #> 0 -> 
%         SC1 #= eval(SC)
%         % append(S, [0], SC1)
%         ; 
%         % append(S, [1], SC1)
%         SC1 #= eval(SC + 1)
%     )
%     ,
%     % ;
%     % true
%     % ),
%     calculate(T, S, SC1, C).

% calculate_inner_sum([], _, TS, TS).
% calculate_inner_sum([H|T], S, SS, TS):-
%     (H #< 0 ->
%     Y #= H*(-1),
%     get_ith(Y, S, E),
%     SS1 #= ((1-E)+SS) ; 
%     %eval(eval(1-E) + SS) ;
%     get_ith(H, S, E),
%     SS1 #= (E+SS)
%     ), 
%     %eval(E + SS)),
%     calculate_inner_sum(T, S, SS1, TS).


maxsat(NV, NC, D, F, S, M) :-
    create_formula(NV, NC, D, F), !,
    length(S, NV),
    S #:: 0..1,
    calculate(F, S, [], Clauses),
    Cost #= sum(Clauses),
    bb_min(search(S, 0, occurrence, indomain, complete, []), Cost, bb_options{strategy:dichotomic}),
    M #= NC-Cost.



calculate([], _, M, M).
calculate([H|T], S, SM, M):-
    calculate_inner_sum(H, S, 0, S1),
    % SM1 #= eval(SM + eval(neg(S1))),
    % append(SM, [neg(S1)], SM1),
    append(SM, [neg(S1)], SM1),
    calculate(T, S, SM1, M).

calculate_inner_sum([], _, TS, TS).
calculate_inner_sum([H|T], S, SS, TS):-
    (H #< 0 ->
    Y #= H*(-1),
    get_ith(Y, S, E),
    SS1 #= (neg(E) or SS) ;
    get_ith(H, S, E),
    SS1 #= (E or SS)),
    calculate_inner_sum(T, S, SS1, TS).

get_ith(1, [H|_], H):- !.
get_ith(I, [_|T], E):-
  I1 is I - 1,
  get_ith(I1, T, E).