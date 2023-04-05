:- compile(activity).

% % activity/2 encodes activities that should be staffed by individuals.
% % Each activity(A, act(S,E)) means that activity A begins at time S and ends at time E.

% % assignment/4 delegates the given activities to the given people in a feasible manner,
% % returning two equivalent representations of the assignment.

% assignment(NP, MT, ASP, ASA) :-
%     % Gather all activities in list AIds
%     findall(AId, activity(AId, _), AIds),
%     % Initialize ASP and ASA
%     init_lists(NP, ASP, ASA),
%     % Assign activities to people
%     assign(AIds, NP, MT, ASA, ASP).

% % Initialize ASP and ASA
% init_lists(NP, ASP, ASA) :-
%     % Initialize ASP with empty list and total time 0 for each person
%     length(ASP, NP),
%     maplist(init_person, ASP),
%     % Initialize ASA with empty list
%     length(ASA, 0).

% % Initialize a person with empty list and total time 0
% init_person(person([], 0)).

% % Assign activities to people
% assign([], _, _, _, ASP) :-
%     % Update ASP with total time for each person
%     update_asp(ASP).
% assign([AId|AIds], NP, MT, ASA, ASP) :-
%     % Select a person PId for activity AId
%     between(1, NP, PId),
%     % Check if current assignment is consistent with previous ones
%     is_valid_assignment(AId, PId, ASA, ASP, MT),
%     % Add AId to PId's assigned activities list
%     add_to_person(AId, PId, ASP),
%     % Add AId-PId to ASA
%     add_to_asa(AId, PId, ASA),
%     % Recursively assign remaining activities
%     assign(AIds, NP, MT, ASA, ASP),
%     % Remove AId from PId's assigned activities list (backtracking)
%     remove_from_person(AId, PId, ASP),
%     % Remove AId-PId from ASA (backtracking)
%     remove_from_asa(AId, PId, ASA).

% % Check if current assignment is consistent with previous ones
% is_valid_assignment(AId, PId, ASA, ASP, MT) :-
%     % Get start and end times of AId
%     activity(AId, act(Ab, Ae)),
%     % Get all activities of PId in ASA
%     findall(APId, member(APId-PId, ASA), APIds),
%     % Check if current assignment is valid
%     is_valid_activity(APIds, Ab, Ae, ASP, MT, 0).

% % Check if an activity is valid
% is_valid_activity([], _, _, _, _, _).
% is_valid_activity([APId|APIds], Ab, Ae, ASP, MT, TT) :-
%     % Get start and end times of APId
%     activity(APId, act(Ab2, Ae2)),
%     % Calculate total time for APId
%     TT1 is (Ae2-Ab2+TT),
%     % Calculate total time for AId
%     TT2 is ((Ae-Ab)+TT1),
%     % Check if total time for PId does not exceed MT
%     TT2 =< MT,
%     % Check if there is at least one unit of time between successive activities of PId
%     Ab2-Ae>=1,
%     % Recursively check remaining activities
%     is_valid_activity(APIds, Ab, Ae, ASP, MT, TT1).

% % Add an activity to a person's assigned activities list and update total time add_to_person(AId, PId, ASP) :-

assignment(NP, MT, ASP, ASA) :-
    findall(AId, activity(AId, _), AIds), % Gather all activities in list AIds
    assign(AIds, NP, MT, [], [], [], ASP, ASA).

assign([], _, _, [], [], ASP, ASP, ASA).
assign([AId|AIds], NP, MT, CurASP, PrevASP, CurASA, ASP, ASA) :-
    assign(AIds, NP, MT, CurASP, PrevASP, CurASA, ASP, ASA1),
    activity(AId, act(Ab, Ae)),
    select_person(Ab, Ae, NP, MT, PrevASP, CurASP, PId),
    append(CurASP, [PId-[AId]-Ae], NewCurASP),
    append(CurASA, [AId-PId], NewCurASA),
    assign(AIds, NP, MT, NewCurASP, CurASP, NewCurASA, ASP, ASA).

select_person(Ab, Ae, NP, MT, PrevASP, CurASP, PId) :-
    between(1, NP, PId),
    \+ member(PId-_, CurASP), % Ensure the person is not already assigned an activity in the current assignment
    \+ overlaps(Ab, Ae, CurASP), % Ensure the person does not overlap with any activity in the current assignment
    \+ overlaps(Ab, Ae, PrevASP), % Ensure the person does not overlap with any activity in the previous assignments
    get_total_time(PId, CurASP, TT),
    TT1 is TT + (Ae - Ab),
    TT1 =< MT,
    !,
    PId.

overlaps(Ab, Ae, ASP) :-
    member(_-Acts-_T, ASP),
    member(AId, Acts),
    activity(AId, act(Ab1, Ae1)),
    Ab < Ae1,
    Ae > Ab1.

get_total_time(PId, ASP, TT) :-
    findall(T, member(PId-Acts-T, ASP), Durations),
    sumlist(Durations, TT).


between(L, U, L) :-
    L=<U.
between(L, U, X) :-
    L<U,
    L1 is L+1,
    between(L1, U, X).