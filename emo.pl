emo(L1, L2):-
    emo_helper(L1, [], L2).

emo_helper([], L, L).
emo_helper([H], SoFar, L2):- append(SoFar, [H], L2).
emo_helper([H|T], SoFar, L2):-
    reverse(T, [H1|T1]),
    append(SoFar, [H,H1], NewSoFar),
    reverse(T1, T2),
    emo_helper(T2, NewSoFar, L2).
