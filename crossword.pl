/* Notes:
 *
 *      1.
 *
 *      2.
 *
 *      3.
 *
 */

:- compile("crosswords/cross01").

crossword(S) :-
    make_tmpl(T), 
    make_domains(T, [], Domains),
    combine_soldom(T, Domains, SolDom),
    generate_solution_with_fc_mrv(SolDom),
    % make_sol(T, [], S),
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
   update_domains(X, SolDom2, SolDom3).
%    generate_solution_with_fc_mrv(SolDom3).

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
   remove_if_exists(X, Domain1, Domain2),
   writeln(Domain1).

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
    % writeln(NewSoFar).

make_domain(H, Domain):-
    % writeln(H),
    length(H, N),
    words(Words),
    findall(Ascii, (member(X, Words), name(X, Ascii), length(Ascii, N1), N =:= N1), Domain).
    % writeln(Domain).
    % writeln(N).

make_tmpl(T) :-
    dimension(D),
    horizontal(1, 0, D, 0, [], H),
    vertical(0, 1, D, 0, [], V),
    append(H, V, T).

horizontal(N, N, N, _, R, R).
horizontal(I, J, N, C, SoFar, R):-
    J =:= N,
    (C > 1 ->
    length(T, C),
    % writeln(T),
    append(SoFar, [T], NewSoFar) ; NewSoFar = SoFar, true),
    I1 is I+1,
    horizontal(I1, 0, N, 0, NewSoFar, R).
horizontal(I, J, N, C, SoFar, R):-
    J < N,
    J1 is J+1,
    (
        black(I, J1) ->
        (C > 1 ->
        length(T, C),
        % writeln(T),
        append(SoFar, [T], NewSoFar)
        ; NewSoFar = SoFar, true),
        C1 is 0 ;
        NewSoFar = SoFar,
        C1 is C+1
    ),
    horizontal(I, J1, N, C1, NewSoFar, R).

vertical(N, N, N, _, R, R).
vertical(I, J, N, C, SoFar, R):-
    I =:= N,
    (C > 1 ->
    length(T, C),
    % writeln(T),
    append(SoFar, [T], NewSoFar) ; NewSoFar = SoFar, true),
    J1 is J+1,
    vertical(0, J1, N, 0, NewSoFar, R).
vertical(I, J, N, C, SoFar, R):-
    I < N,
    I1 is I+1,
    (
        black(I1, J) ->
        (C > 1 ->
        length(T, C),
        % writeln(T),
        append(SoFar, [T], NewSoFar)
        ; NewSoFar = SoFar, true),
        C1 is 0 ;
        NewSoFar = SoFar,
        C1 is C+1
    ),
    vertical(I1, J, N, C1, NewSoFar, R).