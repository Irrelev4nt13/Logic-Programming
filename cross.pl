:- compile("crosswords/cross05").


crossword(S):-
    make_tmpl(T, K),
    make_domains(T, [], Domains),
    combine_soldom(T, Domains, SolDom),
    generate_solution_with_fc_mrv(SolDom),
    make_sol(T, [], S),
    % writeln(K),

    !.




make_sol([], S, S).
make_sol([H|T], SoFar, S):-
    name(L, H),
    append(SoFar, [L], NewSoFar),
    make_sol(T, NewSoFar, S).

generate_solution_with_fc_mrv([]).
generate_solution_with_fc_mrv(SolDom1) :-
   mrv_var(SolDom1, X-Domain, SolDom2),
   member(X, Domain),
   update_domains(X, SolDom2, SolDom3),
   generate_solution_with_fc_mrv(SolDom3).

mrv_var([X-Domain], X-Domain, []).
mrv_var([X1-Domain1|SolDom1], X-Domain, SolDom3) :-
   mrv_var(SolDom1, X2-Domain2, SolDom2),
   length(Domain1, N1),
   length(Domain2, N2),
   (N1 < N2 ->
      (X = X1,
       Domain = Domain1,
       SolDom3 = SolDom1) ;
      (X = X2,
       Domain = Domain2,
       SolDom3 = [X1-Domain1|SolDom2])).

update_domains(_, [], []).
update_domains(X, [Y-Domain1|SolDom1], [Y-Domain2|SolDom2]) :-
   update_domain(X, Domain1, Domain2),
   update_domains(X, SolDom1, SolDom2).

update_domain(X, Domain1, Domain2) :-
   remove_if_exists(X, Domain1, Domain2).


remove_if_exists(_, [], []).
remove_if_exists(X, [X|List], List) :-
   !.
remove_if_exists(X, [Y|List1], [Y|List2]) :-
   remove_if_exists(X, List1, List2).

combine_soldom([], _, []).
combine_soldom([X|S], [Domain|RestDomains], [X-Domain|SolDom]) :-
   combine_soldom(S, RestDomains, SolDom).

make_domains([], Domains, Domains).
make_domains([H|T], SoFar, Domains):-
    make_domain(H, Domain),
    append(SoFar, [Domain], NewSoFar),
    make_domains(T, NewSoFar, Domains).

make_domain(H, Domain):-
    length(H, N),
    words(Words),
    findall(Ascii, (member(X, Words), name(X, Ascii), length(Ascii, N1), N =:= N1), Domain).












make_tmpl(T, K) :-
    dimension(D),
    test(0, D, [], K),
    horizontal(1, 0, D, K, [], [], H),
    vertical(0, 1, D, K, [], [], V),
    append(H, V, T).


vertical(N, N, N, _, _, R, R).
vertical(I, J, N, T, C, SoFar, R):-
    I =:= N,
    length(C, P),
    (P > 1 -> append(SoFar, [C], NewSoFar)
    % , 
    % writeln(C)
    ; NewSoFar = SoFar),
    J1 is J+1,
    vertical(0, J1, N, T, [], NewSoFar, R).
vertical(I, J, N, T, C, SoFar, R):-
    I < N,
    I1 is I+1,
    get_ith(I1, T, L1),
    get_ith(J, L1, E),
    (   var(E) ->
        NewSoFar = SoFar,
        append(C, [E], C1)
        ;
        length(C, P),
        (P > 1 ->
        append(SoFar, [C], NewSoFar)
        % ,
        % writeln(C) 
        ; NewSoFar = SoFar, true ),
        C1 = []
    ),
    vertical(I1, J, N, T, C1, NewSoFar, R).


horizontal(N, N, N, _, _, R, R).
horizontal(I, J, N, T, C, SoFar, R):-
    J =:= N,
    length(C, P),
    (P > 1 -> append(SoFar, [C], NewSoFar)
    % , writeln(C)
    ; NewSoFar = SoFar),
    I1 is I+1,
    horizontal(I1, 0, N, T, [], NewSoFar, R).

horizontal(I, J, N, T, C, SoFar, R):-
    J < N,
    J1 is J+1,
    get_ith(I, T, L1),
    get_ith(J1, L1, E),
    (   var(E) ->
        NewSoFar = SoFar,
        append(C, [E], C1)
        ;
        length(C, P),
        (P > 1 ->
        append(SoFar, [C], NewSoFar)
        % ,writeln(C) 
        ; NewSoFar = SoFar,true ),
        C1 = []
    ),
    horizontal(I, J1, N, T, C1, NewSoFar, R).

test(D, D, S, S):- nl, nl.
test(I, D, SoFar, S):-
    I < D,
    I1 is I+1, 
    findall(J, black(I1, J), BB),
    length(TempList, D),
    test2(BB, TempList),
    % writeln(TempList),
    append(SoFar, [TempList], NewSoFar),
    test(I1, D, NewSoFar, S).

test2([], _).
test2([H|T], TempList):-
    get_ith(H, TempList, E),
    E = ###,
    test2(T, TempList).

get_ith(1, [H|_], H):- !.
get_ith(I, [_|T], E):-
  I1 is I - 1,
  get_ith(I1, T, E).



% go_all:-
%     compile("crosswords/cross01"),
%     cputime(T1),
%     crossword(S),
%     cputime(T2),
%     T is T2-T1,
%     writeln(S),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross02"),
%     cputime(T1),
%     crossword(K),
%     cputime(T2),
%     T is T2-T1,
%     writeln(K),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross03"),
%     cputime(T1),
%     crossword(M),
%     cputime(T2),
%     T is T2-T1,
%     writeln(M),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross04"),
%     cputime(T1),
%     crossword(N),
%     cputime(T2),
%     T is T2-T1,
%     writeln(N),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross05"),
%     cputime(T1),
%     crossword(B),
%     cputime(T2),
%     T is T2-T1,
%     writeln(B),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross06"),
%     cputime(T1),
%     crossword(V),
%     cputime(T2),
%     T is T2-T1,
%     writeln(V),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross07"),
%     cputime(T1),
%     crossword(C),
%     cputime(T2),
%     T is T2-T1,
%     writeln(C),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross08"),
%     cputime(T1),
%     crossword(X),
%     cputime(T2),
%     T is T2-T1,
%     writeln(X),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross09"),
%     cputime(T1),
%     crossword(Z),
%     cputime(T2),
%     T is T2-T1,
%     writeln(Z),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross10"),
%     cputime(T1),
%     crossword(A),
%     cputime(T2),
%     T is T2-T1,
%     writeln(A),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross11"),
%     cputime(T1),
%     crossword(D),
%     cputime(T2),
%     T is T2-T1,
%     writeln(D),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross12"),
%     cputime(T1),
%     crossword(F),
%     cputime(T2),
%     T is T2-T1,
%     writeln(F),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross13"),
%     cputime(T1),
%     crossword(G),
%     cputime(T2),
%     T is T2-T1,
%     writeln(G),
%     write('Time: '),
%     write(T),
%     writeln(' secs.'),
%     compile("crosswords/cross14"),
%     cputime(T1),
%     crossword(H),
%     cputime(T2),
%     T is T2-T1,
%     writeln(H),
%     write('Time: '),
%     write(T),
%     writeln(' secs.').

