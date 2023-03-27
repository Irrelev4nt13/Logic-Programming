:- compile(activity).

% ASP lista me stoixeia
% N-As-T 

% [ Atomo - [lista drastiriotion] - Sinolikos Xronos ]


% ASA lista me stoixeia
% A-N

% [ Drastiriotika - Atomo ]


% In general 
% activity(A, act(S, E)).

% A -> activity
% S -> starting time
% E -> ending time

% NP -> number of people
% MT -> maximum total time

% assignment(NP, MT, ASP, ASA):-
    % get_act([],MT,0,ASP).
    % write(NP),
    % write('\n'),
    % print(MT),
    % helper(1,NP).
    % avoid_overlapping_activities([],L1).
    % ASP = [NP-[a15]-MT].

helper(Lim,NP):-
    Lim > 0,
    Lim =< NP,
    write(Lim),
    Lim1 is Lim + 1,
    helper(Lim1,NP).
% lastElement([_],_).
% lastElement([_|T],L):-
%     lastElement(T,L).  
% last([X],X).
% last([_|T],R):- 
%     last(T,R).
% get_act(L):-
%     get_act([],14,0,L).
% get_act(SoFar,MT,T,L):-
% % get_act(SoFar,L):-
%     activity(X,act(S,E)),
%     \+ member(X,SoFar),
%     % append([H],T,SoFar),
%     % last(SoFar,Y),
%     % member(H,SoFar),
%     % activity(H,act(_,E2)),
%     % (S-E2) >= 1,
%     % write(Y),
%     % write(Y),
%     T1 is (E-S)+T,
%     (S-T1) >= 1,
%     T1 =< MT,
%     append([X],SoFar,NewSoFar),
%     get_act(NewSoFar,MT,T1,L),
%     % get_act(NewSoFar,L),
%     !.
% get_act(L,_,T,L-T).
% % get_act(L,L).

% assignment(NP, MT, ASP, ASA):-
%     temp([],MT,0,)

test(NP,X):-
    between(1,NP, X).

between(L,U,L):-
    L=<U.
between(L,U,X):-
    L<U,
    L1 is L+1,
    between(L1,U,X).


temp([],MT,T,L):-
    activity(X,act(S,E)),
    T1 is (E-S)+T,
    T1 =< MT,
    append([X],[],NewSoFar),
    temp(NewSoFar,MT,T1,E,L),
    !.
temp(SoFar,MT,T,LE,L):-
    activity(X,act(S,E)),
    \+ member(X,SoFar),
    (S-LE) > 0 ,
    T1 is (E-S)+T,
    T1 =< MT,
    append([X],SoFar,NewSoFar),
    temp(NewSoFar,MT,T1,E,L).
temp(L,_,T,_,L-T).    