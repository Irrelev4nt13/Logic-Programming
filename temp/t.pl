:- compile(activity2).

assignment(NP, ASA):-
    findall(AId, activity(AId, _), AIds),
    assign(AIds, NP, [], ASA).

assignment(NP, MT, _, ASA) :-
    findall(AId, activity(AId, _), AIds), % Gather all activities in list AIds
    assign(AIds, NP, MT, ASA).

assign([], _, _, []).
assign([AId|AIds], NP, MT, [AId-PId|ASA]) :-
    assign(AIds, NP, MT, ASA),
    between(1, NP, PId), % Select a person PId for activity AId
    activity(AId, act(Ab, Ae)),
    findall(APId, member(APId-PId, ASA), APIds), % Gather in list APIds so far activities of PId
    valid(Ab, Ae, MT, 0, APIds). % Is current assignment consistent with previous ones?

valid(_, _, _, _, []).
valid(Ab1, Ae1, MT, TT, [APId|APIds]) :-
    activity(APId, act(Ab2, Ae2)),
    TT1 is (Ae2-Ab2+TT),
    % TT2 is ((Ae1-Ab1)+TT1),
    % TT2=<MT,
    Ab2-Ae1>=1,
    valid(Ab1, Ae1, MT, TT1, APIds).

between(L, U, L) :-
    L=<U.
between(L, U, X) :-
    L<U,
    L1 is L+1,
    between(L1, U, X).