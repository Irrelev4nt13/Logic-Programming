/* Notes:
 *
 *      1. The InitialState is a list of number which represents the diameter of each pancake. In order to ensure
 *         that the user gives a correct sequence of pancakes I made a predicate called initial_state. It takes 
 *         as input a list and checks whether or not it has a valid sequence of pancakes. Since the pancakes are from
 *         1-N, with N be the size of the list it must containts number from 1-N. This is what the predicate checks.
 *         We are using the length of the list to find all number from 1 to N with the help of the all_between predicate.
 *         Given a lower bound, L, and an upper bound U, it returns a list with number from 1 to N. After that we have,
 *         implemented a predicate called permutation which returns all the permutations for a given list. In this case,
 *         we can use it in the otherway around. What I mean is that we can give it the list with numbers from 1 to N,
 *         and the InitialState which is given as input from the user. If the InitialState is a possible permutation
 *         then the execution we will continute otherwise it will stop.
 *               
 *      2. Our goal is to sort the «tower» of pancakes in a way that the pancakes are in asceding order from top to bottom.
 *         For that reason I made a predicate which checks if a given list is «sorted» in asceding order. 
 *         Each time it checks if the head of the list is less or equal to the second element of the list. 
 *         If it's true we continute the recursion with from the second element to the end and so on.
 *         If it's not true then it stops and obviously it's not the final_state we want to end up to.
 *      
 *      3. pancakes_dfs is a predicate which takes as input an InitialState and through depth first search it returns a list 
 *         called Operators which containts all the pancakes in which we place the spatoula in order to make a flip. Also,
 *         it returns a list called States which containts all the states we need to go through, according to the operators as well,
 *         to end up to the final_state.
 *         
 *      4. In order for the above to be achieved we need to make a predicate called move. The aforementioned is a predicate of 3rd grade,
 *         it takes as input a State1 which represents a current state of the tower with the pancakes and returns the State2 which is 
 *         the tower after the flip according to the Operator which is also returned. We first append serves to find the pancakes 
 *         above the Operator, the pancakes in which we will put the spatoula, and flip them with the reverse. At last, we append
 *         the operator with the reversed above part and the rest pancakes in the State2.
 *      
 *      5. Bonus: 
 *               We were asked to make an implementation of the iterative deepening search which is able to find all solutions 
 *               for the first successfull depth. In order to achieve that we need to modify the first definition of the iter predicate.
 *               After the cut operator we call the idfs for the same limit. Practically, the 1st call of idfs serves to find the depth
 *               to which the first solutions exists, thats why we used unknown variables for the results, while the 2nd call is used to 
 *               get the solutions. It should be noted mention that the first solutions is 2 times but we "count" (show it) one time.
 *               Last but not least, we need to explaine the predicate_ids which takes as input an InitialState and through the modified
 *               idfs it returns a list called Operators which containts all the pancakes in which we place the spatoula in order to make a flip.
 *               Also, it returns a list called States which containts all the states we need to go through, according to the operators as well,
 *               to end up to the final_state.
 */

initial_state(State) :-
    length(State, Size),
    all_between(1, Size, L),
    permutation(State, L).

permutation([], []).
permutation([Head|Tail], PermList) :-
    permutation(Tail, PermTail),
    del(Head, PermList, PermTail).

del(Item, [Item|List], List).
del(Item, [First|List], [First|List1]) :-
    del(Item, List, List1).

all_between(L, U, []) :-
    L>U.
all_between(L, U, [L|X]) :-
    L=<U,
    L1 is L+1,
    all_between(L1, U, X).

final_state([_]).
final_state([H, S|T]) :-
    H=<S,
    final_state([S|T]).

pancakes_dfs(InitialState, Operators, States) :-
    initial_state(InitialState),
    dfs(InitialState, [InitialState], States, [], Operators).

dfs(State, States, States, Operators, Operators) :-
    final_state(State).
dfs(State1, SoFarStates, States, SoFarOperators, Operators) :-
    move(State1, State2, Operator),
    \+ member(State2, SoFarStates),
    append(SoFarOperators, [Operator], NewSoFarOperators),
    append(SoFarStates, [State2], NewSoFarStates),
    dfs(State2, NewSoFarStates, States, NewSoFarOperators, Operators).

move(State1, State2, Operator) :-
    append(Above_op, [Operator|Under_op], State1),
    reverse(Above_op, RevAbove_op),
    append([Operator|RevAbove_op], Under_op, State2).

pancakes_ids(InitialState, Operators, States) :-
    initial_state(InitialState),
    iter(0, InitialState, States, Operators).

iter(Lim, InitialState, States, Operators) :-
    idfs(Lim, InitialState, [InitialState], _, [], _),
    !,
    idfs(Lim, InitialState, [InitialState], States, [], Operators).
iter(Lim, InitialState, States, Operators) :-
    Lim1 is Lim+1,
    iter(Lim1, InitialState, States, Operators).

idfs(_, State, States, States, Operators, Operators) :-
    final_state(State).
idfs(Lim, State1, SoFarStates, States, SoFarOperators, Operators) :-
    Lim>0,
    Lim1 is Lim-1,
    move(State1, State2, Operator),
    \+ member(State2, SoFarStates),
    append(SoFarOperators, [Operator], NewSoFarOperators),
    append(SoFarStates, [State2], NewSoFarStates),
    idfs(Lim1, State2, NewSoFarStates, States, NewSoFarOperators, Operators).