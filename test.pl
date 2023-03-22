initial_state([3, 2, 1, 4]).
final_state([1, 2, 3, 4]).

move(State1, State2) :-
    length(State1, N1),              /* Number of pancakes plus the plate */
    N is N1-1,                                    /* Number of pancakes */
    between(1, N, Operator),               /* Select a pancake to reverse
                                                 the whole stack above it */
    State1\=[Operator|_],         /* This should not be the top pancake */
    append(Prefix, [Operator|Rest], State1),    /* Isolate pancakes above
                                               the one acting as operator */
    reverse(Prefix, RevPrefix),                           /* Reverse them */
    append([Operator|RevPrefix], Rest, State2).  /* Build the final stack */
dfs(States) :-
    initial_state(State),
    depth_first_search(State, [State], States).

depth_first_search(State, States, States) :-
    final_state(State).

depth_first_search(State1, SoFarStates, States) :-
    move(State1, State2),
    \+ member(State2, SoFarStates),
    append(SoFarStates, [State2], NewSoFarStates),
    depth_first_search(State2, NewSoFarStates, States).
