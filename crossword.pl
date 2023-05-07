/*
 * TODO:
 *      1. Get white boxes
 *      2. Assign them to variables with form X_i
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */


:- compile("crosswords/cross01").

crossword(S):-   
    dimension(D),
    findall((X,Y), black(X,Y), BlackBoxes),
    % writeln(D),
    % writeln(BlackBoxes),
    make_tmpl(D, Board),
    writeln(Board),
    writeln("\n"),
    Board = [H|_],
    H = [T|_],
    writeln(H),
    writeln("\n"),
    name(T,[97]),
    writeln(T),
    writeln("\n"),
    print_crossword(Board).
    % length(T,D).
    % findall((X,Y),(between(1,D,X),between(1,D,Y),\+member((X,Y),BlackBoxes)), A),
    % make_tmpl(0,0,D).


make_tmpl(D, Board):-
    make_tmpl(0, D, [], Board).
make_tmpl(D, D, B, B):-!.
make_tmpl(I, D, B, B1):-
    I < D, 
    length(T, D),
    append(B, [T], B2),
    I1 is I+1,
    make_tmpl(I1, D, B2, B1).
% make_tmpl(I, D, BlackBoxes, Board):-
%     I < N,
%     length(S, D), 
%     append()
% make_tmpl(_, N,N,N).
% make_tmpl(C, I, N, N):- nl,
%     I < N-1,
%     I1 is I+1,
%     make_tmpl(C, I1,0,N).
% make_tmpl(C, I, J, N):-
%     J < N,
%     J1 is J+1,
%     IT is I+1,
%     (black(IT,J1) -> print(###) ; (print("X"),
%     print(C), C1 is C+1)),
%     print(" "),
%     make_tmpl(C1, I, J1, N).

print_crossword([]).
print_crossword([H|T]):-
    print_helper(H),
    print_crossword(T),!.

print_helper([]).
print_helper([X]):- 
    (X \= ### -> write(' ') ; true), 
    write(X), 
    (X \= ### -> writeln(' ') ; writeln('')).
print_helper([H|T]):-
    (H \= ### -> write(' ') ; true),
    write(H),
    (H \= ### -> write(' ') ; true),
    print_helper(T).

between(L, U, L) :-
    L=<U.
between(L, U, X) :-
    L<U,
    L1 is L+1,
    between(L1, U, X).


all_between(L, U, []) :-
    L>U.
all_between(L, U, [L|X]) :-
    L=<U,
    L1 is L+1,
    all_between(L1, U, X).