matr_transp([], []):- !.
matr_transp([[]|_], []):- !.
matr_transp(Matrix, [FirstCol|Transposed]) :-
    transpose_column(Matrix, FirstCol, RestMatrix),
    matr_transp(RestMatrix, Transposed).

transpose_column([], [], []):- !.
transpose_column([[Elem|Row]|Rest], [Elem|FirstCol], [Row|RestMatrix]) :-
    transpose_column(Rest, FirstCol, RestMatrix).
