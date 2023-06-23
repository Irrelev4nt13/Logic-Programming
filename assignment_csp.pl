/* Notes:
 *
 */

:- compile("activities/activity_big").

% :- lib(gfd).
% :- lib(gfd_search).
:- lib(ic).
:- lib(branch_and_bound).

% For the csp model the ic is faster 
assignment_csp(NP, MT, ASP, ASA):-
    findall(X, activity(X, _), A), length(A, NA), length(AVR, NA), length(W, NP),
    AVR #:: 1..NP,
    % AVR :: 1..NP,
    constraints(AVR, A, W, NP, MT),
    search(AVR, 0, input_order, indomain, complete, []),
    findall(Elem-X, (between(1, NA, Index), get_ith(Index, A, Elem), get_ith(Index, AVR, X)), ASA),
    findall(PId-APIds-WT, (between(1, NP, PId), findall(APId, member(APId-PId, ASA), APIds), get_ith(PId, W, WT)), ASP).

constraints(AVR, A, W, NP, MT):-
    overload(AVR, A, W, 0, NP, MT),
    symmetric(AVR),
    overlap(AVR, A, 1).

overload(_, _, _, NP, NP, _).
overload(AVR, A, [H|T], I, NP, MT):-
    I < NP,
    I1 is I+1,
    overload_helper(AVR, A, I1, 0, WorkLoad),
    H #= eval(WorkLoad), H #=< MT,
    overload(AVR, A, T, I1, NP, MT).

overload_helper([], [], _, WorkLoad, WorkLoad).
overload_helper([X|Xs], [A|As], P, Sum, WorkLoad):-
    activity(A, act(S, F)),
    Sum1 = (((X #= P)*(F-S)) + Sum),
    overload_helper(Xs, As, P, Sum1, WorkLoad).

symmetric([H|T]):-
    H #= 1,
    symmetric_helper([H], T).

symmetric_helper(_, []).
symmetric_helper(Before, [H|T]):-
    H #=< max(Before) + 1,
    append(Before, [H], NewBefore),
    symmetric_helper(NewBefore, T).

overlap(_, [], _).
overlap(AVR, [H|T], I):-
    I1 is I+1,
    overlap_helper(AVR, H, I, T, I1), 
    overlap(AVR, T, I1).

overlap_helper(_, _, _, [], _).
overlap_helper(AVR, X, I, [H|T], I1):-
    activity(X, act(S1, F1)),
    activity(H, act(S2, F2)),
    ((S2-F1 >= 1 ; S1-F2 >= 1) -> true ;
    element(I, AVR, P1),
    element(I1, AVR, P2),
    P1 #\= P2),
    I2 is I1+1,
    overlap_helper(AVR, X, I, T, I2).

% Definitions of possible auxiliary predicates
get_ith(1, [H|_], H):- !.
get_ith(I, [_|T], E):-
  I1 is I - 1,
  get_ith(I1, T, E).

sum_time([], S, S).
sum_time([APId|T], S0, S) :-
    activity(APId, act(S1, E)),
    S2 is S0 + (E - S1),
    sum_time(T, S2, S).
    
between(L, U, L) :-
    L=<U.
between(L, U, X) :-
    L<U,
    L1 is L+1,
    between(L1, U, X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Testing multiple Select and Choice options %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assignment_csp(NP, MT, ASP, ASA, Select, Choice):-
    findall(X, activity(X, _), A), length(A, NA), length(AVR, NA),
    AVR #:: 1..NP,
    % AVR :: 1..NP,
    constraints(AVR, A, NP, MT),
    search(AVR, 0, Select, Choice, complete, []),
    findall(Elem-X, (between(1, NA, Index), get_ith(Index, A, Elem), get_ith(Index, AVR, X)), ASA),
    findall(PId-APIds-T, (between(1, NP, PId), findall(APId, member(APId-PId, ASA), APIds), sum_time(APIds, 0, T)), ASP).

go_all_1(NP, MT, Select, Choice):-
    cputime(T1),
    findall(sol, assignment_csp(NP, MT, _, _, Select, Choice), Solutions), length(Solutions, N),
    cputime(T2),
    T is T2-T1,
    write('There are '),
    write(N),
    writeln(' solutions.'),
    write('Time: '),
    write(T),
    writeln(' secs.').

% I tested the last example in order to see differences in time because the previous 
% had very small differences in terms of time between the each select and choice and option 
% which is not ideal in order to decide what's fastest.
% Below are noted the top 5 fastest combinations in ascending time order.
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% TOP VALUES FOR IMPLEMENTATION WITH GFD %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------
% Select: occurrence Choice: indomain NP: 5 MT: 9
% --------------------------------
% There are 63852 solutions.
% Time: 3.10974225699999 secs.
%
% --------------------------------
% Select: input_order Choice: indomain NP: 5 MT: 9
% --------------------------------
% There are 63852 solutions.
% Time: 3.109839879 secs.
%
% --------------------------------
% Select: first_fail Choice: indomain NP: 5 MT: 9
% --------------------------------
% There are 63852 solutions.
% Time: 3.11407339700001 secs.
%
% --------------------------------
% Select: most_constrained Choice: indomain NP: 5 MT: 9
% --------------------------------
% There are 63852 solutions.
% Time: 3.114460339 secs.
%
% --------------------------------
% Select: max_regret Choice: indomain NP: 5 MT: 9
% --------------------------------
% There are 63852 solutions.
% Time: 3.11619416399999 secs.
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% TOP VALUES FOR IMPLEMENTATION WITH IC %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------
% Select: input_order Choice: indomain NP: 5 MT: 9
% --------------------------------
% There are 63852 solutions.
% Time: 1.694684603 secs.
%
% --------------------------------
% Select: first_fail Choice: indomain NP: 5 MT: 9
% --------------------------------
% There are 63852 solutions.
% Time: 1.731780618 secs.
%
% --------------------------------
% Select: input_order Choice: indomain_min NP: 5 MT: 9
% --------------------------------
% There are 63852 solutions.
% Time: 1.793838541 secs.
%
% --------------------------------
% Select: input_order Choice: indomain_max NP: 5 MT: 9
% --------------------------------
% There are 63852 solutions.
% Time: 1.795739943 secs.
%
% --------------------------------
% Select: input_order Choice: indomain_split NP: 5 MT: 9
% --------------------------------
% There are 63852 solutions.
% Time: 1.800764776 secs.
%
go_all_1 :-
    member(Select, [
                    anti_first_fail,
                    first_fail,
                    input_order,
                    largest,
                    max_regret,
                    most_constrained,
                    occurrence,
                    smallest
                    ]),
    NP is 5, 
    MT is 9,
    member(Choice, [
                    indomain,
                    indomain_interval,
                    indomain_max,
                    indomain_median,
                    indomain_min,
                    indomain_random,
                    indomain_reverse_split,
                    indomain_split
                    ]),
    nl,
    write('--------------------------------'),
    nl,
    write('Select: '),
    write(Select),
    write(' Choice: '),
    write(Choice),
    write(' NP: '),
    write(NP),
    write(' MT: '),
    write(MT),
    nl,
    write('--------------------------------'),
    nl,
    go_all_1(NP, MT, Select, Choice),
    fail.


% For the opt model the ic is faster 
assignment_opt(NF, NP, MT, F, T, ASP, ASA, Cost):-
    (NF =:= 0 -> 
    findall(X, activity(X, _), As); 
    get_activities(0, NF, [], As)), 
    length(As, NA), length(AVR, NA), length(W, NP),
    totaltime(As, 0, D),
    A is integer(round(D/NP)),
    AVR #:: 1..NP,
    % AVR :: 1..NP,
    constraints(AVR, As, W, NP, MT),
    cost(W, A, 0, C),
    Cost #= eval(C),
    LB #= abs(D-(A*NP)),
    bb_min(search(AVR, 0, most_constrained, heuristic(W, _), complete, []), Cost, bb_options{from:LB,delta:F,timeout:T}),
    % bb_min(gfd_search:search(AVR, 0, input_order, heuristic(W, _), complete, []), Cost, bb_options{from:LB,delta:F,timeout:T}),
    findall(Elem-X, (between(1, NA, Index), get_ith(Index, As, Elem), get_ith(Index, AVR, X)), ASA),
    findall(PId-APIds-WT, (between(1, NP, PId), findall(APId, member(APId-PId, ASA), APIds), get_ith(PId, W, WT)), ASP).

get_activities(NF, NF, As, As):- !.
get_activities(I, NF, SoFar, As):-
    I < NF, 
    I1 is I+1,
    activity(X, _),
    \+member(X, SoFar), !,
    append(SoFar, [X], NewSoFar),
    get_activities(I1, NF, NewSoFar, As).

totaltime([], TT, TT).
totaltime([H|T], Sum, TT):-
    activity(H, act(S, F)),
    Sum1 is Sum + (F - S), 
    totaltime(T, Sum1, TT).

cost([], _, Cost, Cost).
cost([W|T], As, Sum, Cost):-
    TempSum #= As - W,
    Sum1 = (TempSum * TempSum) + Sum,
    cost(T, As, Sum1, Cost).

heuristic(X, In, In):-
    (var(X) -> 
        get_minimums(In, 0, [], Mins),
        quicksort(Mins, Sorted),
        member(_-P, Sorted),
        X #= P ; true).

quicksort([], []).
quicksort([X-N|Tail], Sorted) :-
    split(X, Tail, Small, Big),
    quicksort(Small, SortedSmall),
    quicksort(Big, SortedBig),
    append(SortedSmall, [X-N|SortedBig], Sorted).

gt(X, Y) :- X > Y.

split(_, [], [], []).
split(X, [Y|Tail], [Y|Small], Big) :-
    gt(X, Y),
    !,
    split(X, Tail, Small, Big).
split(X, [Y|Tail], Small, [Y|Big]) :-
    split(X, Tail, Small, Big).

get_minimums([], _, L, L).
get_minimums([H|T], I, SoFar, L):-
    get_min(H, X),
    I1 is I+1,
    append(SoFar, [X-I1], NewSoFar),
    get_minimums(T, I1, NewSoFar, L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Testing multiple Select options %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assignment_opt(NF, NP, MT, F, T, ASP, ASA, Cost, Select):-
    (NF =:= 0 -> 
    findall(X, activity(X, _), As); 
    get_activities(0, NF, [], As)), 
    length(As, NA), length(AVR, NA), length(W, NP),
    totaltime(As, 0, D),
    A is integer(round(D/NP)),
    AVR #:: 1..NP,
    % AVR :: 1..NP,
    constraints(AVR, As, W, NP, MT),
    cost(W, A, 0, C),
    Cost #= eval(C),
    LB #= abs(D-(A*NP)),
    bb_min(search(AVR, 0, Select, heuristic(W, _), complete, []), Cost, bb_options{from:LB,delta:F,timeout:T}),
    % bb_min(gfd_search:search(AVR, 0, Select, heuristic(W, _), complete, []), Cost, bb_options{from:LB,delta:F,timeout:T}), 
    findall(Elem-X, (between(1, NA, Index), get_ith(Index, As, Elem), get_ith(Index, AVR, X)), ASA),
    findall(PId-APIds-WT, (between(1, NP, PId), findall(APId, member(APId-PId, ASA), APIds), get_ith(PId, W, WT)), ASP).

go_all_2(NF, NP, MT, F, T, Select):-
    cputime(T1),
    assignment_opt(NF, NP, MT, F, T, _, _, Cost, Select),
    cputime(T2),
    T3 is T2-T1,
    write('The cost is '),
    writeln(Cost),
    write('Time: '),
    write(T3),
    writeln(' secs.').

% I tested the example with 80 activities in order to see differences in time because the previous 
% had very small differences in terms of time between the each select and choice and option 
% which is not ideal in order to decide what's fastest.
% Below are noted all combinations in ascending time order.
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% TOP VALUES FOR IMPLEMENTATION WITH GFD %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------
% Select: most_constrained NF: 80 NP: 10 MT: 65 F: 0.8 T: 0
% --------------------------------
% The cost is 1
% Time: 1.5152382 secs.
% 
% --------------------------------
% Select: first_fail NF: 80 NP: 10 MT: 65 F: 0.8 T: 0
% --------------------------------
% The cost is 1
% Time: 41.716426506 secs.
% 
% --------------------------------
% Select: input_order NF: 80 NP: 10 MT: 65 F: 0.8 T: 0
% --------------------------------
% The cost is 1
% Time: 153.449480654 secs.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% TOP VALUES FOR IMPLEMENTATION WITH IC %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------
% Select: most_constrained NF: 80 NP: 10 MT: 65 F: 0.8 T: 0
% --------------------------------
% The cost is 1
% Time: 0.966187043 secs.
% 
% --------------------------------
% Select: first_fail NF: 80 NP: 10 MT: 65 F: 0.8 T: 0
% --------------------------------
% The cost is 1
% Time: 9.758394238 secs.
% 
% --------------------------------
% Select: input_order NF: 80 NP: 10 MT: 65 F: 0.8 T: 0
% --------------------------------
% The cost is 1
% Time: 22.743701473 secs.
% 
go_all_2 :-
    member(Select, [
                    anti_first_fail,
                    first_fail,
                    input_order,
                    largest,
                    max_regret,
                    most_constrained,
                    occurrence,
                    smallest
                    ]),
    NF is 80,
    NP is 10, 
    MT is 65,
    F is 0.8, 
    T is 0,
    nl,
    write('--------------------------------'),
    nl,
    write('Select: '),
    write(Select),
    write(' NF: '),
    write(NF),
    write(' NP: '),
    write(NP),
    write(' MT: '),
    write(MT),
    write(' F: '),
    write(F),
    write(' T: '),
    write(T),
    nl,
    write('--------------------------------'),
    nl,
    go_all_2(NF, NP, MT, F, T, Select),
    fail.