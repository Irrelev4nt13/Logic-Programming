sel(X, [X|Tail], Tail).
sel(X, [_|Tail], R) :-
  sel(X, Tail, R).
