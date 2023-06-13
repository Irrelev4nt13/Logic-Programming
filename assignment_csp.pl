/* Notes:
 *
 */

% assignment_csp(3, 14, ASP, ASA).
% assignment_csp(2, 40, ASP, ASA).
% assignment_csp(3, 13, ASP, ASA).
% findall(sol, assignment_csp(5, 8, _, _), Solutions), length(Solutions, N).
% findall(sol, assignment_csp(5, 9, _, _), Solutions), length(Solutions, N).

% assignment_csp(2, 10, ASP, ASA).
% findall(sol, assignment_csp(2, 10, _, _), Solutions), length(Solutions, N).

% findall(sol, assignment_csp(3, 14, _, _), Solutions), length(Solutions, N).


:- compile("activities/activity_big").

% I had to comment the ic lib because in the assignment_opt I used gfd which was better
% If you would like to see the max potential of the csp comment the gfd lib and uncomment the ic
% :- lib(gfd).
:- lib(ic).
:- lib(branch_and_bound).

% For the csp model the ic is faster 
assignment_csp(NP, MT, ASP, ASA):-
    findall(X, activity(X, _), A), length(A, NA), length(AVR, NA),
    AVR #:: 1..NP,
    % AVR :: 1..NP,
    constraints(AVR, A, NP, MT),
    search(AVR, 0, input_order, indomain, complete, []),
    findall(Elem-X, (between(1, NA, Index), get_ith(Index, A, Elem), get_ith(Index, AVR, X)), ASA),
    findall(PId-APIds-T, (between(1, NP, PId), findall(APId, member(APId-PId, ASA), APIds), sum_time(APIds, 0, T)), ASP).

constraints(AVR, A, NP, MT):-
    overload(AVR, A, 0, NP, MT),
    symmetric(AVR),
    overlap(AVR, A, 1).

overload(_, _, NP, NP, _).
overload(AVR, A, I, NP, MT):-
    I < NP,
    I1 is I+1,
    overload_helper(AVR, A, I1, 0, WorkLoad),
    eval(WorkLoad) #=< MT,
    overload(AVR, A, I1, NP, MT).

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
    member(Select, [anti_first_fail,
                    first_fail,
                    input_order,
                    largest,
                    max_regret,
                    most_constrained,
                    occurrence,
                    smallest]),
    NP is 5, 
    MT is 9,
    member(Choice, [indomain,
                    indomain_interval,
                    indomain_max,
                    indomain_median,
                    indomain_min,
                    indomain_random,
                    indomain_reverse_split,
                    indomain_split]),
    % member(Option, [continue,
    %                 restart,
    %                 step,
    %                 dichotomic]),
    nl,
    write('--------------------------------'),
    nl,
    write('Select: '),
    write(Select),
    write(' Choice: '),
    write(Choice),
    % write(' Option: '),
    % write(Option),
    write(' NP: '),
    write(NP),
    write(' MT: '),
    write(MT),
    nl,
    write('--------------------------------'),
    nl,
    go_all_1(NP, MT, Select, Choice),
    fail.


% assignment_opt(10, 5, 15, 1.0, 0, ASP, ASA, Cost).
% assignment_opt(20, 5, 25, 1.0, 0, ASP, ASA, Cost).
% assignment_opt(30, 4, 50, 1.0, 0, ASP, ASA, Cost).
% assignment_opt(50, 7, 60, 1.0, 0, ASP, ASA, Cost).
% assignment_opt(70, 10, 80, 1.0, 20, ASP, ASA, Cost).
% assignment_opt(80, 10, 65, 0.8, 0, ASP, ASA, Cost).
% assignment_opt(0, 12, 100, 0.9, 10, ASP, ASA, Cost).


% assignment_opt(100, 50, 200, 1.0, 60, ASP, ASA, Cost).
% assignment_opt(200, 100, 100, 0.9, 120, ASP, ASA, Cost).
% assignment_opt(0, 120, 80, 0.8, 180, ASP, ASA, Cost).

% heuristic ascending workload
% find lower bound of the cost which if the bb_min finds it, it will stop the iteration
% from is the attribute for the lower bound

% assignment_opt(0, 3, 14, 0, 0, ASP, ASA, 0).

% assignment_opt(16, 5, 15, 1.0, 0, ASP, ASA, Cost).

assignment_opt(NF, NP, MT, F, T, ASP, ASA, Cost):-
    (NF =:= 0 -> 
    findall(X, activity(X, _), A); 
    get_activities(0, NF, [], A)),
    length(A, NA), length(AVR, NA),
    totaltime(A, 0, D),
    A1 is integer(round(D/NP)),
    AVR #:: 1..NP,
    constraints(AVR, A, NP, MT),
    % search(AVR, 0, input_order, indomain, complete, []),
    length(Persons, NP), 
    weight(AVR, A, NA, Persons, 0, NP),
    cost(Persons, A1, 0, Cost1),
    writeln(Persons),
    Cost #= eval(Cost1),
    bb_min(search(AVR, 0, input_order, indomain_reverse_split, complete, []), Cost, bb_options{delta:F,timeout:T}),
    findall(Elem-X, (between(1, NA, Index), get_ith(Index, A, Elem), get_ith(Index, AVR, X)), ASA),
    findall(PId-APIds-T1, (between(1, NP, PId), findall(APId, member(APId-PId, ASA), APIds), sum_time(APIds, 0, T1)), ASP).

get_activities(NF, NF, A, A).
get_activities(I, NF, SoFar, A):-
    I < NF, 
    I1 is I+1,
    activity(X, _),
    \+member(X, SoFar),
    append(SoFar, [X], NewSoFar),
    get_activities(I1, NF, NewSoFar, A).

weight(_, _, _, [], NP, NP).
weight(AVR, A, NA, [H|T], I, NP):-
    I < NP, 
    I1 is I + 1, 
    findall(Assignment, (between(1, NA, Index), get_ith(Index, A, Assignment), get_ith(Index, AVR, X), X #= I1), L), 
    % length(L, Y),
    nl,writeln(L),nl,
    % weight(L)
    weight_helper(L, 0, W),
    % writeln(L),
    % writeln(W), nl,
    H #= eval(W),
    weight(AVR, A, NA, T, I1, NP).

weight_helper([], W, W).
weight_helper([H|T], Sum, W):-
    activity(H, act(S, F)),
    Sum1 = (F-S) + Sum,
    weight_helper(T, Sum1, W).

overload(_, _, NP, NP, _).
overload(AVR, A, I, NP, MT):-
    I < NP,
    I1 is I+1,
    overload_helper(AVR, A, I1, 0, WorkLoad),
    eval(WorkLoad) #=< MT,
    overload(AVR, A, I1, NP, MT).

overload_helper([], [], _, WorkLoad, WorkLoad).
overload_helper([X|Xs], [A|As], P, Sum, WorkLoad):-
    activity(A, act(S, F)),
    Sum1 = (((X #= P)*(F-S)) + Sum),
    overload_helper(Xs, As, P, Sum1, WorkLoad).

totaltime([], TT, TT).
totaltime([H|T], Sum, TT):-
    activity(H, act(S, F)),
    Sum1 is Sum + (F - S), 
    totaltime(T, Sum1, TT).

cost([], _, Cost, Cost).
cost([W|T], A, Sum, Cost):-
    TempSum = (A - eval(W)),
    Sum1 = eval((TempSum * TempSum) + Sum),
    % write(W), write(' '), write(TempSum), write(' '), write(Sum), write(' '), writeln(Sum1),
    cost(T, A, Sum1, Cost).
    
    