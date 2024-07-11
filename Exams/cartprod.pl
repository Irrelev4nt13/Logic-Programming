cartprod([], [[]]).
cartprod([Set|Sets], Product) :-
    cartprod(Sets, Rest),
    findall([X|Tuple], (member(X, Set), member(Tuple, Rest)), Product).
