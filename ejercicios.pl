% ============================================================
%  EJERCICIOS CODIFICADOS - Caballeros y Truhanes
%  Cargar junto con solver.pl:  ?- [solver].  ?- [ejercicios].
% ============================================================

% -----------------------------------------------------------
%  EJERCICIO 14
%  A: B es caballero
%  B: Si A es caballero entonces C también lo es.
% -----------------------------------------------------------
personajes(ej14, [a, b, c]).
declara(ej14, a, cab(b)).
declara(ej14, b, si(cab(a), cab(c))).

% -----------------------------------------------------------
%  EJERCICIO 15
%  A: B y C son del mismo tipo
%  B: Soy truhan o caballero
% -----------------------------------------------------------
personajes(ej15, [a, b, c]).
declara(ej15, a, sii(cab(b), cab(c))).
declara(ej15, b, o(tru(b), cab(b))).

% -----------------------------------------------------------
%  EJERCICIO 17 (plantilla)
%  B: o bien A dijo que no era caballero, o yo digo que todos somos truhanes
%  C: exactamente dos de nosotros somos truhanes
% -----------------------------------------------------------
%% personajes(ej17, [a, b, c]).
%% declara(ej17, b, o(no(cab(a)), y(tru(a), y(tru(b), tru(c))))).
%% declara(ej17, c, exactamente(2, [a, b, c])).

% -----------------------------------------------------------
%  EJERCICIO 18 (plantilla - puertas y guardias)
%  Se necesitan proposiciones sobre puertas además de roles.
% -----------------------------------------------------------
%% % A: El tesoro está en la puerta negra o en la blanca
%% %% declara(ej18, a, o(puerta(negra), puerta(blanca))).
%% % C: A y B no son ambos truhanes
%% %% declara(ej18, c, no(y(tru(a), tru(b)))).
%% % D: Si A es caballero entonces B también lo es
%% %% declara(ej18, d, si(cab(a), cab(b))).
%% % E: Yo soy truhan y C y D no son del mismo tipo
%% %% declara(ej18, e, y(tru(e), no(sii(cab(c), cab(d))))).

% ============================================================
%  FIN DE ejercicios.pl
% ============================================================
