:- compile("activities/activity2").

assignment(NPersons, Assignment) :-
    findall(AId, activity(AId, _), AIds), % Gather all activities in list AIds
    assign(AIds, NPersons, Assignment).

assign([], _, []).
assign([AId|AIds], NPersons, [AId-PId|Assignment]) :-
    assign(AIds, NPersons, Assignment),
    between(1, NPersons, PId), % Select a person PId for activity AId
    activity(AId, act(Ab, Ae)),
    findall(APId, member(APId-PId, Assignment), APIds), % Gather in list APIds so far activities of PId
    valid(Ab, Ae, APIds). % Is current assignment consistent with previous ones?

valid(_, _, []).
valid(Ab1, Ae1, [APId|APIds]) :-
    activity(APId, act(Ab2, Ae2)),
    (Ab2-Ae1 >= 1 ; Ab1-Ae2 >= 1),
    valid(Ab1, Ae1, APIds).

% Definitions of possible auxiliary predicates
between(L, U, L) :-
    L=<U.
between(L, U, X) :-
    L<U,
    L1 is L+1,
    between(L1, U, X).

task(t1,[a,b,c]). 
task(t2,[a,d]). 
task(t3,[b,d,e,f]). 
task(t4,[c,e]). 
task(t5,[f]).


tsched(Deadline, Schedule) :-
    findall(T/Rs, task(T, Rs), Tasks),
    schall(Tasks, Deadline, [], Schedule).

schall([], _, Schedule, Schedule).
schall([T/Rs|Tasks], Deadline, SoFarSchedule, Schedule) :-
    between(1, Deadline, N), 
    \+ (member(T1/N, SoFarSchedule), 
       task(T1, Rs1),
       member(R, Rs1),
       member(R, Rs)
    ),
    append(SoFarSchedule, [T/N], NewSoFarSchedule),
    schall(Tasks, Deadline, NewSoFarSchedule, Schedule).
% between


max_clique(N, Edges, MaxCl, MaxSize) :-
    clique(N, Edges, MaxCl, MaxSize),
    \+ (clique(N, Edges, _, MaxSize1), MaxSize1 > MaxSize).

clique(N, Edges, Clique, Size) :-
    findall(K, between(1, N, K), Nodes),
    is_subset(Nodes, Clique),
    \+ (member(I, Clique), member(J, Clique), I<J, \+ member(I-J, Edges)),
    length(Clique, Size).

% between
is_subset([], _).
is_subset([X|Xs], Set) :-
    member(X, Set), !,
    is_subset(Xs, Set).
