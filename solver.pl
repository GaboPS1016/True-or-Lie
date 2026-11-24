% ============================================================
%  SOLUCIONADOR DE ACERTIJOS DE CABALLEROS Y TRUHANES
%  Lógica Proposicional - Paradigma Declarativo (Prolog)
%  Compatible con SWI-Prolog
% ============================================================

% -----------------------------------------------------------
% 1. SINTAXIS DE FÓRMULAS PROPOSICIONALES
% -----------------------------------------------------------
% Los constructores disponibles para escribir declaraciones:
%
%   cab(X)              X es caballero (siempre dice la verdad)
%   tru(X)              X es truhan   (siempre miente)
%   no(F)               negación       (¬F)
%   y(F1, F2)           conjunción     (F1 ∧ F2)
%   o(F1, F2)           disyunción     (F1 ∨ F2)
%   si(F1, F2)          implicación    (F1 → F2)
%   sii(F1, F2)         bicondicional  (F1 ↔ F2)
%   exactamente(N, Lista) exactamente N de Lista son truhanes
%
% Nota: se usan letras minúsculas para los nombres de personajes (a, b, c...)

% -----------------------------------------------------------
% 2. HECHOS QUE DEFINEN CADA PROBLEMA (el usuario los escribe)
% -----------------------------------------------------------
%
% personajes(Problema, [P1, P2, ...])      - lista de habitantes
% declara(Problema, Personaje, Formula)    - lo que dice cada personaje
%
% Ejemplo:
%   personajes(ej14, [a, b, c]).
%   declara(ej14, a, cab(b)).
%   declara(ej14, b, si(cab(a), cab(c))).

% -----------------------------------------------------------
% 3. MOTOR DE EVALUACIÓN DE FÓRMULAS
% -----------------------------------------------------------
% Asignacion es una lista de pares Personaje-rol, ej:
%   [a-caballero, b-truhan, c-caballero]

% --- Átomos: rol de un personaje ---
eval(cab(X), As) :- member(X-caballero, As), !.
eval(cab(_), _) :- fail.

eval(tru(X), As) :- member(X-truhan, As), !.
eval(tru(_), _) :- fail.

% --- Negación ---
eval(no(F), As) :- \+ eval(F, As).

% --- Conjunción ---
eval(y(F1, F2), As) :- eval(F1, As), eval(F2, As).

% --- Disyunción (inclusive) ---
eval(o(F1, F2), As) :- eval(F1, As) ; eval(F2, As).

% --- Implicación: F1 → F2 es falso solo si F1 verdadero y F2 falso ---
eval(si(F1, F2), As) :- \+ (eval(F1, As), \+ eval(F2, As)).

% --- Bicondicional: F1 ↔ F2 (ambos mismo valor de verdad) ---
eval(sii(F1, F2), As) :-
    (   eval(F1, As) -> eval(F2, As)
    ;   \+ eval(F1, As), \+ eval(F2, As)
    ).

% --- Exactamente N de Lista son truhanes ---
eval(exactamente(N, Lista), As) :-
    findall(X, (member(X, Lista), member(X-truhan, As)), Truhanes),
    length(Truhanes, N).

% -----------------------------------------------------------
% 4. CONDICIÓN DE CONSISTENCIA
% -----------------------------------------------------------
% Regla fundamental de caballeros y truhanes:
%   caballero(X)  ↔  su declaración es verdadera
%   truhan(X)    ↔  su declaración es falsa
%
% Esto se codifica como: el rol de X debe coincidir con el valor
% de verdad de su declaración bajo la asignación actual.

personaje_consistente(Problema, As, X) :-
    (   declara(Problema, X, Formula)
    ->  (   member(X-caballero, As) -> eval(Formula, As)
        ;   member(X-truhan, As) -> \+ eval(Formula, As)
        )
    ;   true
    ).

es_consistente(Problema, As) :-
    personajes(Problema, Personajes),
    maplist(personaje_consistente(Problema, As), Personajes).

% -----------------------------------------------------------
% 5. BÚSQUEDA DE TODAS LAS SOLUCIONES (backtracking de Prolog)
% -----------------------------------------------------------

% Genera una asignación de roles (caballero o truhan) para cada personaje
generar_asignacion([], []).
generar_asignacion([X|Xs], [X-R|Rs]) :-
    (R = caballero ; R = truhan),
    generar_asignacion(Xs, Rs).

% Predicato principal: encuentra UNA asignación consistente.
% Prolog hace backtracking automático si el usuario pide más soluciones (;).
resolver(Problema, Asignacion) :-
    personajes(Problema, Personajes),
    generar_asignacion(Personajes, Asignacion),
    es_consistente(Problema, Asignacion).

% -----------------------------------------------------------
% 6. PREDICADOS DE UTILIDAD PARA EL USUARIO
% -----------------------------------------------------------

% Cuenta cuántas soluciones tiene el problema
contar_soluciones(Problema, N) :-
    findall(_Asignacion, resolver(Problema, _Asignacion), Lista),
    length(Lista, N).

% Muestra todas las soluciones de forma legible
mostrar_soluciones(Problema) :-
    personajes(Problema, Personajes),
    findall(Asignacion, resolver(Problema, Asignacion), Soluciones),
    (   Soluciones = [] ->
        writeln('>>> No hay solución: el problema es INCONSISTENTE.')
    ;   Soluciones = [_] ->
        writeln('>>> Solución ÚNICA encontrada:'),
        maplist(mostrar_una_asignacion, Soluciones)
    ;   length(Soluciones, Cant),
        writeln('>>> Se encontraron '), write(Cant), writeln(' soluciones posibles:'),
        maplist(mostrar_una_asignacion, Soluciones)
    ).

mostrar_una_asignacion(Asignacion) :-
    writeln('---'),
    maplist(mostrar_par, Asignacion).

mostrar_par(X-R) :-
    write('  '), write(X), write(' = '), write(R), nl.

% -----------------------------------------------------------
% 7. EJEMPLOS INCLUIDOS (Ejercicios 14 y 15 de tu lista)
% -----------------------------------------------------------

% ---- Ejercicio 14 ----
% A: B es caballero
% B: Si A es caballero entonces C también lo es.
personajes(ej14, [a, b, c]).
declara(ej14, a, cab(b)).
declara(ej14, b, si(cab(a), cab(c))).

% ---- Ejercicio 15 ----
% A: B y C son del mismo tipo
% B: Soy truhan o caballero   (tautología)
personajes(ej15, [a, b, c]).
declara(ej15, a, sii(cab(b), cab(c))).
declara(ej15, b, o(tru(b), cab(b))).

% ---- Ejercicio 17 (plantilla) ----
% B: o bien A dijo que no era caballero, o yo digo que todos somos truhanes
% C: exactamente dos de nosotros somos truhanes
% personajes(ej17, [a, b, c]).
% declara(ej17, b, o(no(cab(a)), y(tru(a), y(tru(b), tru(c))))).
% declara(ej17, c, exactamente(2, [a, b, c])).

% -----------------------------------------------------------
% 8. CONSULTAS DE EJEMPLO
% -----------------------------------------------------------
%
% En SWI-Prolog, cargar el archivo y luego:
%
%   ?- [solver].
%   ?- resolver(ej14, Sol).
%   ;   % (punto y coma para ver más soluciones)
%
%   ?- mostrar_soluciones(ej14).
%   ?- mostrar_soluciones(ej15).
%   ?- contar_soluciones(ej14, N).
%

% ============================================================
%  FIN DE solver.pl
% ============================================================
