/* Notes:
 *
 * 1. The InitialState is a list of number which represents the diameter of each pancake.
 * 
 * 2. Our goal is to sort the «tower» of pancakes in a way that the pancakes are in asceding order from top to bottom.
 * 
 * 3. 
 *
 * 
 */
% A state is represented by a list of numbers.
% The initial state is not different from a state.
% It is a state which is represented by a list of numbers.
initial_state([_|_]).

% The final state is a list with all elements in asceding order.
% The base case is a list with one item which is already "sorted".
% We could also check the empty list but it's unnecessary.
% In any other case we traverse the list and compare it's head with the second element.
% If it satisfies the criterias then we recursively call the final state to check
% The rest of the list starting from the second element as the head and so on.
final_state([_]).
final_state([H, S|T]) :-
    H=<S,
    final_state([S|T]).

% InitialState to arxiko state
% Operators ta pancakes kato apo ta opoia benei h spatoula
% States h lista me ola ta states mexri na ftasei ston stoxo
pancakes_dfs(InitialState, Operators, States) :-
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
    append(Prefix, [Operator|Rest], State1),
    reverse(Prefix, RevPrefix),
    append([Operator|RevPrefix], Rest, State2).


pancakes_ids(InitialState, Operators, States) :-
    iter(0, InitialState,States,Operators).


iter(Lim, InitialState,States,Operators) :-
    idfs(Lim, InitialState, [InitialState], States,[],Operators),
    !.
iter(Lim, InitialState, States,Operators) :-
    Lim1 is Lim+1,
    iter(Lim1, InitialState, States,Operators).

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