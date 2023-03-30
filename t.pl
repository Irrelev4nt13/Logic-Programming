
initial_state(State):-
    length(State,Size),
    all_between(1,Size,L),
    permutation(State,L).

permutation([], []).
permutation([Head|Tail], PermList) :-
    permutation(Tail, PermTail),
    del(Head, PermList, PermTail).

del(Item, [Item|List], List).
del(Item, [First|List], [First|List1]) :-
    del(Item, List, List1).

all_between(L,U,[]):- 
    L>U.
all_between(L,U,[L|X]):-
    L=<U,
    L1 is L+1,
    all_between(L1,U,X).

% between()


% InitialState = [1,2,500], initial_state(InitialState).

% pancakes_dfs([3, 2, 4, a], Operators, States).

