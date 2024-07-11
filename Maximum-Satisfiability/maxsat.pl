/* Notes:
 *      
 *      1. In this particular modeling we see the problem as the minimization of unsatisfied clauses.
 *           
 *      2. The predicate calculate_inner_sum given an element of the list F, i.e a list (clause) and S calculates and returns whether the clause is satified with 
 *         the current value assignments. If the clause containts negation we treat it by multipliying the index by -1 and then append the value in the list of Clauses.
 *         Then the recursion with element the tail of F continues. Then we sum up the list of clauses with the help of the predicate sum from ic in order to find M and 
 *         Cost. Until now the solution would be decent but not excellent, in order to fix that we think reversed. What I mean is we can first find the values for Clauses
 *         and then, based on the values of the Clauses search for the values of S, this way we avoid finding symmetric solution which would cause our execution to take 
 *         too long to finish.          
 *
 *      3. Finally, in order to achieve faster execution I created a go_all predicate which given a list of Select and Choice and Options it calls the maxsat/9 
 *         which takes as arguments the Select, Choice and Option. After the execution it prints the run time and move to the next combination. In that section I
 *         have noted some of the fastest combinations I found.
 */

:- set_flag(print_depth, 1000).
:- lib(ic).
:- lib(branch_and_bound).

maxsat(NV, NC, D, F, S, M) :-
    create_formula(NV, NC, D, F), !,
    length(S, NV),
    S #:: 0..1,
    calculate(F, S, [], Clauses),
    M #= sum(Clauses),
    Cost #= NC-M,
    bb_min((search(Clauses, 0, input_order, indomain_reverse_split, complete, []),
        search(S, 0, input_order, indomain_reverse_split, complete, [])), 
        Cost, 
        bb_options{strategy:restart}).

calculate([], _, M, M).
calculate([H|T], S, SM, M):-
    calculate_inner_sum(H, S, 0, S1),
    append(SM, [S1], SM1),
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Testing multiple Select and Choice options %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxsat(NV, NC, D, F, S, M, Select, Choice, Option) :-
    create_formula(NV, NC, D, F),
    writeln(F),
    length(S, NV),
    S #:: 0..1,
    calculate(F, S, [], Clauses),
    M #= sum(Clauses),
    Cost #= NC-M,
    bb_min((search(Clauses, 0, Select, Choice, complete, []),
        search(S, 0, Select, Choice, complete, [])), 
        Cost, 
        bb_options{strategy:Option}).

go_all(NV, NC, D, Seed, Select, Choice, Option):-
    cputime(T1),
    seed(Seed), maxsat(NV, NC, D, _, _, _, Select, Choice, Option),
    cputime(T2),
    T is T2-T1,
    write('Time: '),
    write(T),
    writeln(' secs.').

% I tested the second to last example in order to see differences in time because the previous 
% had very small differences in terms of time between the each select and choice and option which is 
% not ideal in order to decide what's fastest.
% Below are noted the top 5 fastest combinations in ascending time order.
% 
% --------------------------------
% Select: input_order Choice: indomain_reverse_split Option: restart NV: 50 NC: 250 D: 9
% --------------------------------
% Time: 0.0671332379999967 secs.
% 
% --------------------------------
% Select: input_order Choice: outdomain_min Option: dichotomic NV: 50 NC: 250 D: 9
% --------------------------------
% Time: 0.0674608180000007 secs.
% 
% --------------------------------
% Select: input_order Choice: outdomain_min Option: restart NV: 50 NC: 250 D: 9
% --------------------------------
% Time: 0.0676205489999973 secs.
% 
% --------------------------------
% Select: input_order Choice: indomain_reverse_split Option: step NV: 50 NC: 250 D: 9
% --------------------------------
% Time: 0.0679708639999888 secs.
% 
% --------------------------------
% Select: input_order Choice: indomain_reverse_split Option: continue NV: 50 NC: 250 D: 9
% --------------------------------
% Time: 0.0692036359999975 secs.
% 
go_all :-
    member(Select, [anti_first_fail,
                    first_fail,
                    input_order,
                    largest,
                    max_regret,
                    most_constrained,
                    occurrence,
                    smallest]),
    Seed is 567, 
    NV is 50, 
    NC is 250, 
    D is 9,
    member(Choice, [indomain,
                    indomain_interval,
                    indomain_max,
                    indomain_median,
                    indomain_middle,
                    indomain_min,
                    indomain_random,
                    indomain_reverse_split,
                    indomain_split,
                    outdomain_max,
                    outdomain_min]),
    member(Option, [continue,
                    restart,
                    step,
                    dichotomic]),
    nl,
    write('--------------------------------'),
    nl,
    write('Select: '),
    write(Select),
    write(' Choice: '),
    write(Choice),
    write(' Option: '),
    write(Option),
    write(' NV: '),
    write(NV),
    write(' NC: '),
    write(NC),
    write(' D: '),
    write(D),
    nl,
    write('--------------------------------'),
    nl,
    go_all(NV, NC, D, Seed, Select, Choice, Option),
    fail.