assignment(NPersons, Assignment) :-
    .................................., % Gather all activities in list AIds
    assign(AIds, NPersons, Assignment).
assign([], _, []).
assign([AId|AIds], NPersons, [AId-PId|Assignment]) :-
    assign(AIds, NPersons, Assignment),
    .................................., % Select a person PId for activity AId
    activity(AId, act(Ab, Ae)),
    .................................., % Gather in list APIds so far activities of PId
    valid(Ab, Ae, APIds). % Is current assignment consistent with previous ones?
valid(_, _, []).
valid(Ab1, Ae1, [APId|APIds]) :-
    activity(APId, act(Ab2, Ae2)),
    ..................................,
    valid(Ab1, Ae1, APIds).
..................................... % Definitions of possible auxiliary predicates