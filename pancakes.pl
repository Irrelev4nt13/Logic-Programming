% :- compile(dfs).

% A state is represented by a list of numbers.
% The initial state is not different from a state.
% It is state which is represented by a list of numbers.
initial_state([_|_]).

% The final state is a list with all elements in asceding order.
% The base case is a list with one item which is already "sorted".
% In any other case we traverse the list and compare it's head with the next element.
% If it satisfies the critirias then we recursivly call the final_state to check,
% The rest of the list starting from the second element and so on.
final_state([_]).
final_state([H, E|T]) :-
    H=<E,
    final_state([E|T]).

% reverse_fast(L, R) :-
%     rev_help(L, [], R).

% rev_help([], R, R).
% rev_help([X|L], Acc, R) :-
%     rev_help(L, [X|Acc], R).


% InitialState to arxiko state
% Operators ta pancakes kato apo ta opoia benei h spatoula
% States h lista me ola ta states mexri na ftasei ston stoxo
pancakes_dfs(InitialState, Operators, States) :-
    State = InitialState,
    dfs(State, [State], States,Operators).

dfs(State, States, States,_) :-
    final_state(State).
dfs(State1, SoFarStates, States, Operators) :-
    move(State1, State2),
    \+ member(State2, SoFarStates),
    % Na paro to proto stoixeio tou neou state kai na to balo sta operator
    append([E],[_|_], State2),
    append(Operators, [E], NewOperators),
    append(SoFarStates, [State2], NewSoFarStates),
    dfs(State2, NewSoFarStates, States, NewOperators).


move(State1, State2) :-
    % State1\=[Operator|_],
    append(Prefix, [Operator|Rest], State1),
    reverse(Prefix, RevPrefix),
    append([Operator|RevPrefix], Rest, State2).
% move(State1, State2) :-
%     append([H|T], )