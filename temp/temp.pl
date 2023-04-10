:- compile(activity).

assignment(NP, MT, ASP, ASA) :-
    findall(AId, activity(AId, _), AIds), % Gather all activities in list AIds
    assign(AIds, NP, MT, ASA),
    % between(1, NP, PId),
    findall(X, member(X-1, ASA), Temp),
    findall(Y, member(Y-2, ASA), Temp2),
    findall(Z, member(Z-3, ASA), Temp3),
    temp(Temp,0,T1),
    temp(Temp2,0,T2),
    temp(Temp3,0,T3),
    append([1-Temp-T1],[2-Temp2-T2],ASP_T),
    append(ASP_T,[3-Temp3-T3], ASP).
    % make_asp(1,ASA,_,_).
    % append().

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
    TT2 is ((Ae1-Ab1)+TT1),
    TT2=<MT,
    Ab2-Ae1>=1,
    valid(Ab1, Ae1, MT, TT1, APIds).

% make_asp([],_,ASP,ASP).
% make_asp(ASA,PId,SoFar,ASP):-
%     findall(APId, member(APId-PId, ASA), L),
%     append(ASP,[L],NewSoFar),
% make_asp([],[]).
% make_asp(ASA,ASP):-

temp([],TT,TT).
temp([H|T],CT,TT):-
    activity(H,act(A,B)),
    CT2 is ((B-A)+CT),
    temp(T,CT2,TT).



between(L, U, L) :-
    L=<U.
between(L, U, X) :-
    L<U,
    L1 is L+1,
    between(L1, U, X).

    
   