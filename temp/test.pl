:-compile(activity).
test(NP):-
    ASA = [a01 - 2, a02 - 3, a03 - 1, a04 - 2, a05 - 1, a06 - 3, a07 - 1, a08 - 2, a09 - 1, a10 - 3, a11 - 2, a12 - 1, a13 - 3, a14 - 2, a15 - 1],
    make_asp(NP,ASA,ASP),
    writeln(ASP).
    % make_asp(NP,ASA,1).


make_asp(NP,ASA,ASP) :-
    findall(I-APIds-T, (between(1, NP, I), findall(APId, member(APId-I, ASA), APIds), sum_time(APIds, 0, T)), ASP).
    
sum_time([], S, S).
sum_time([APId|T], S0, S) :-
    activity(APId, act(Start, End)),
    S1 is S0 + (End - Start),
    sum_time(T, S1, S).
% make_asp(NP,ASA,ASP):-
%     make_asp(1,NP,ASA,[],ASP).


% make_asp(I,NP,_,ASP,ASP):-I>NP,!.
% make_asp(I,NP,ASA,SoFar,ASP):-
%     I =< NP,    
%     findall(APId, member(APId-I, ASA), APIds),
%     sum_time(APIds,0,T),
%     I1 is I+1,
%     make_asp(I1, NP, ASA, [I-APIds-T|SoFar],ASP).

% sum_time([], S, S).
% sum_time([H|T], S1, S0):-
%     activity(H, act(S, E)),
%     S2 is (E-S)+S1,
%     sum_time(T, S2, S0).


between(L, U, L) :-
    L=<U.
between(L, U, X) :-
    L<U,
    L1 is L+1,
    between(L1, U, X).