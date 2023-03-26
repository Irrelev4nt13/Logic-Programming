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

% assignment(NP, MT, ASP, ASA,L1):-
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



% avoid_overlapping_activities([],[]).
% avoid_overlapping_activities(SoFar,L1):-
%     activity(A,_),
%     append(SoFar,A,NewSoFar),
%     avoid_overlapping_activities(NewSoFar,L1).

% temp(L,L).
% temp(SoFar,L):-
%     % write(SoFar),
%     % write("\n"),
%     activity(X,_),
%     % temp(T).
%     \+ member(X,SoFar),
%     % temp(T).
%     % write(A),
%     % write("\n"),
%     append(SoFar,X,NewSoFar),
%     % temp(T).
%     temp(NewSoFar,L).

% temp1(A,L):-
%     \+ member(A,L),
%     temp()

% temp(SoFar,L):-
%     activity(A,_),
%     temp1(A,SoFar,NewSoFar),
%     temp(NewSoFar,L).

% temp1(X,L,L2):-
%     append(L,[X],L2).
% temp1(X,L,[]):-
%     member(X,L).
% non_overlapping_tasks_constr([]).
% non_overlapping_tasks_constr([S| Rest]) :-
%     activity(S,_),
% 	non_overlapping_tasks_constr1(S, Rest),
% 	non_overlapping_tasks_constr(Rest).

% non_overlapping_tasks_constr1(_, []).
% non_overlapping_tasks_constr1(S,Rest) :-
% 	\+ member(S, Rest),
	% non_overlapping_tasks_constr1(S , Rest).

activities(L,L):-
    findall(_,activity(_,_),Y),
    length(Y,N),
    length(L,N).
activities(SoFar,L):-
    activity(X,_),
    \+ member(X,SoFar),
    append(SoFar,[X],NewSoFar),
    activities(NewSoFar,L),
    !.