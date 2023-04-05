:- compile(activity).

assignment(NP, MT, ASP, ASA):-
    findall(AId, activity(AId, _), AIds), % Gather all activities in list AIds
    assign(AIds, NP, MT, [], ASA).
    % findall(PId-APIds-T, (between(1, NP, PId), findall(APId, member(APId-PId, ASA), APIds), sum_time(APIds, 0, T)), ASP).
    
assign([], _, _, ASA, ASA).
assign([AId|AIds], NP, MT, SoFarASA, ASA) :-
    between(1, NP, PId), % Select a person PId for activity AId
    activity(AId, act(Ab, Ae)),
    findall(APId, member(APId-PId, SoFarASA), APIds), % Gather in list APIds so far activities of PId
    CT is Ae - Ab,
    valid(Ab, Ae, MT, CT, APIds), % Is current assignment consistent with previous ones?
    % \+member(AId-_,SoFarASA),
    % ASA = [AId-PId|SoFarASA],
    writeln([AId-PId|SoFarASA]),
    assign(AIds, NP, MT, [AId-PId|SoFarASA], ASA).
    % writeln(ASA).

valid(_, _, _, _, []).
valid(Ab1, Ae1, MT, CT, [APId|APIds]):-
    activity(APId, act(Ab2, Ae2)),
    (Ab2-Ae1 >= 1 ; Ab1-Ae2 >= 1),
    CT1 is (CT+(Ae2-Ab2)),
    CT1 =< MT,
    valid(Ab1, Ae1, MT, CT1, APIds).

% Definitions of possible auxiliary predicates
sum_time([], S, S).
sum_time([APId|T], S0, S) :-
    activity(APId, act(Start, End)),
    S1 is S0 + (End - Start),
    sum_time(T, S1, S).

between(L, U, L) :-
    L=<U.
between(L, U, X) :-
    L<U,
    L1 is L+1,
    between(L1, U, X).


% assign([], _, _, ASA, ASA).
% assign([AId|AIds], NP, MT, SoFarASA, ASA) :-
%     between(1, NP, PId), 
%     activity(AId, act(Ab, Ae)),
%     findall(APId, member(APId-_, SoFarASA), APIds), 
%     CT is Ae - Ab,
%     % \+ member(_-PId, SoFarASA),
%     findall(APId, member(APId-PId, SoFarASA), APIds),
%     valid(Ab, Ae, MT, CT, APIds),
%     assign(AIds, NP, MT, [AId-PId|SoFarASA], ASA),
%     \+ (member(_-PPId, SoFarASA), PPId > PId).