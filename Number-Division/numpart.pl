/* Notes:
 *      
 *      1. In order to solve the problem faster, it is preferable to calculate only one list and the second one can be extracted using the predicate difference which, 
 *         as its name says, puts in the third list all the elements that are in the first list but not in the second list. In our case the 1st list is all the numbers 
 *         from 1 - N while the 2nd is the list we calculated previously.
 *           
 *      2. I created a predicate sumlist_square which calculates and returns the sum of the squares of the elements of the given list. In order to know that a list meets 
 *         the criteria, the sum of its elements and the sum of the squares of its elements must be equal to those of the other list. However, we have at our disposal sum 
 *         types which give us the total sum for a list with 1-N elements. However, since we are calculating half the list, we can use the sums divided by 2 to check our 
 *         results. Here Ι should note that after tests the alldifferent of ic turned out to be faster than ic_global.
 * 
 *      3. After the calculation of the sum square in order to check its value we wered guided to use eval because of a weird interaction with the ic recursion in ic.
 * 
 *      4. Last but not least, in order to avoid symmetric solutions we are enforcing the list to be in asceding order which can be easily done by assign the value 1 in 
 *         the first element of the list we are calculating.
 * 
 *      5. Finally, in order to achieve faster search I created a go_all predicate which given a list of Select and Choice options it calls the numpart/5 
 *         which takes as arguments the Select and Choice. After the execution it prints the run time and move to the next combination. In that section I
 *         have noted some of the fastest combinations I found.
 */

:- lib(ic_global).
:- lib(ic).

numpart(N, L1, L2) :-
    N mod 2=:=0,
    N_half is N//2,
    length(L1, N_half),
    L1 #:: 1..N,
    constrain(L1, N),
    search(L1, 0, occurrence, indomain, complete, []),
    all_between(1, N, L),
    difference(L, L1, L2).

constrain([H|T], N):-
    H #= 1,
    ic:alldifferent([H|T]),
    ordered_sum([H|T], S1),
    S2 is N*(N+1)//4,
    S1 #= S2,
    sumlist_square([H|T], S3),
    S4 is N*(N+1)*(2*N+1)//12,
    eval(S3) #= S4.
    
sumlist_square(L, S) :-
    sumlist_square(L, 0, S).
sumlist_square([], S, S).
sumlist_square([X|L], S1, S) :-
    S2 = X*X + S1,
    sumlist_square(L, S2, S). 

difference([], _, []).
difference([X|L1], L2, L3) :-
    member(X, L2), !,
    difference(L1, L2, L3).
difference([X|L1], L2, [X|L3]) :-
    difference(L1, L2, L3).

all_between(L, U, []) :-
    L>U.
all_between(L, U, [L|X]) :-
    L=<U,
    L1 is L+1,
    all_between(L1, U, X).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Testing multiple Select and Choice options %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numpart(N, Select, Choice, L1, L2) :-
    N_half is N//2,
    length(L1, N_half),
    L1 #:: 1..N,
    constrain(L1, N),
    search(L1, 0, Select, Choice, complete, []),
    all_between(1, N, L),
    difference(L, L1, L2).

go_all(N, Select, Choice):-
    cputime(T1),
    findall((L1,L2), numpart(N, Select, Choice, L1, L2), N1),
    cputime(T2),
    length(N1, L),
    T is T2-T1,
    write('There are '),
    write(L),
    writeln(' solutions.'),
    write('Time: '),
    write(T),
    writeln(' secs.').

% 28 is a good number to see differences in run time, 20 or 24 has very small differences 
% between the each select and choice option which is not ideal in order to decide what's fastest
% Below are noted the top 5 fastest combinations in ascending time order.
% 
% --------------------------------
% Select: occurrence Choice: indomain  N: 28
% --------------------------------
% Time: 1.94041294399995 secs.
% 
% --------------------------------
% Select: occurrence Choice: indomain_middle  N: 28
% --------------------------------
% Time: 2.09151846700001 secs.
% 
% --------------------------------
% Select: occurrence Choice: indomain_median  N: 28
% --------------------------------
% Time: 2.16126222899993 secs.
% 
% --------------------------------
% Select: occurrence Choice: indomain_max  N: 28
% --------------------------------
% Time: 2.21006092300013 secs.
% 
% --------------------------------
% Select: occurrence Choice: outdomain_max  N: 28
% --------------------------------
% Time: 2.21169000300006 secs.

go_all :-
    member(Select, [anti_first_fail,
                    first_fail,
                    input_order,
                    largest,
                    max_regret,
                    most_constrained,
                    occurrence,
                    smallest]),
    N is 28,
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
    nl,
    write('--------------------------------'),
    nl,
    write('Select: '),
    write(Select),
    write(' Choice: '),
    write(Choice),
    write('  N: '),
    write(N),
    nl,
    write('--------------------------------'),
    nl,
    go_all(N, Select, Choice),
    fail.