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


assignment(NP, MT, ASP, ASA):-
    write(NP),
    write('\n'),
    print(MT),
    write('\n').
