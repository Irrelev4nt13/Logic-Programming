:- compile(dfs).

% A state is represented by a list of numbers.
state([_|_]).

% The initial state is not different from a state.
% It is state which is represented by a list of numbers.
initial_state(state([_|_])).

% The final state is a list with all elements in asceding order.
% The base case is a list with one item which is already "sorted".
% In any other case we traverse the list and compare it's head with the next element.
% If it satisfies the critirias then we recursivly call the final_state to check,
% The rest of the list starting from the second element and so on.
final_state([_]).
final_state([H, E|T]) :-
    H=<E,
    final_state([E|T]).

reverse_fast(L, R) :-
    rev_help(L, [], R).

rev_help([], R, R).
rev_help([X|L], Acc, R) :-
    rev_help(L, [X|Acc], R).



% pancakes_dfs([], [], []).
move(state((_| _)), state((_| _))).

    % length([H|T], N),
    % X=\=H,
    % X=<N,
    % append(H, [], R),
    % move(X, [T], R).
