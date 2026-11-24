# True-or-Lie

Solucionador declarativo de acertijos de **caballeros y truhanes** (Knights and Knaves) usando **Prolog** y lógica proposicional.

## ¿Qué hace este programa?

Dado un grupo de habitantes que hacen declaraciones sobre quién es caballero y quién es truhan, el programa:

- Prueba **todas las combinaciones posibles** de roles (caballero / truhan).
- Mantiene solo las asignaciones **consistentes** con lo que cada uno dijo:
  - Si es **caballero**, su declaración es **verdadera**.
  - Si es **truhan**, su declaración es **falsa**.
- Te devuelve **el rol de cada personaje** y te indica si el problema tiene:
  - ✅ **Solución única**
  - ⚠️ **Múltiples soluciones**
  - ❌ **Ninguna solución** (el enunciado es inconsistente)

## ¿Por qué Prolog?

Prolog es un lenguaje **declarativo de lógica**, ideal para este tipo de problemas porque:

- El backtracking automático explora todas las combinaciones de roles sin que tengas escribir bucles.
- La unificación y las reglas lógicas se parecen mucho a cómo se escriben las deducciones a mano en tu curso de Lógica.
- Es el estándar clásico para acertijos de Smullyan (caballeros y truhanes).

## Estructura del proyecto

```
True-or-Lie/
├── solver.pl       # Motor reutilizable (no lo necesitas modificar)
├── ejercicios.pl   # Aquí codificas los enunciados de tus ejercicios
└── README.md       # Este archivo
```

## Cómo usar (en SWI-Prolog)

1. Abre SWI-Prolog.
2. Carga el motor:
   ```prolog
   ?- [solver].
   ```
3. Resuelve un ejercicio:
   ```prolog
   ?- resolver(ej14, Sol).
   ```
   Presiona `;` para ver si hay más soluciones.

   O ve todas las soluciones de forma legible:
   ```prolog
   ?- mostrar_soluciones(ej14).
   ```

4. Cuántas soluciones hay:
   ```prolog
   ?- contar_soluciones(ej14, N).
   ```

## Cómo codificar un ejercicio nuevo

En `ejercicios.pl` (o directamente en la consola) defines dos hechos:

```prolog
% 1. Lista de personajes
personajes(mi_problema, [a, b, c]).

% 2. Qué dice cada uno
declara(mi_problema, a, cab(b)).                    % a dice: "b es caballero"
declara(mi_problema, b, si(cab(a), cab(c))).        % b dice: "si a es caballero entonces c lo es"
```

### Constructores disponibles para las declaraciones

| Término Prolog | Significado lógico | Ejemplo |
|---|---|---|
| `cab(X)` | X es caballero | `cab(a)` |
| `tru(X)` | X es truhan | `tru(b)` |
| `no(F)` | NO F | `no(cab(a))` |
| `y(F1, F2)` | F1 ∧ F2 | `y(cab(a), tru(b))` |
| `o(F1, F2)` | F1 ∨ F2 | `o(cab(a), cab(b))` |
| `si(F1, F2)` | F1 → F2 | `si(cab(a), cab(c))` |
| `sii(F1, F2)` | F1 ↔ F2 | `sii(cab(b), cab(c))` |
| `exactamente(N, [L1, L2, ...])` | Exactly N de esa lista son truhanes | `exactamente(2, [a,b,c])` |

### Ejemplo completo (Ejercicio 14)

```prolog
personajes(ej14, [a, b, c]).
declara(ej14, a, cab(b)).
declara(ej14, b, si(cab(a), cab(c))).
```

Consulta:
```prolog
?- mostrar_soluciones(ej14).
```

## Ejercicios de tu lista que se pueden modelar directamente

| Ejercicio | Tipo | Notas |
|---|---|---|
| 14 | Caballeros/Truhanes | ✅ Incluido en `ejercicios.pl` |
| 15 | Caballeros/Truhanes | ✅ Incluido en `ejercicios.pl` |
| 17 | Caballeros/Truhanes | ⚠️ Plantilla (habla de lo que A dijo) |
| 18 | Guardias + puertas | ⚠️ Requiere añadir proposiciones de puerta |
| 19 | Bloques + apagones | ⚠️ Requiere variables de bloque |
| 21 | Culpabilidad (Craig) | ⚠️ Similar, pero con culpables/no culpables |
| 22 | Sacerdotes + impostor | ⚠️ Uno y solo un truhan entre caballeros |

Los ejercicios 13, 20 y 23 son del **inspector Craig** (sobre culpabilidad y cómplices), no caballeros/truhanes puros. Se pueden resolver con el mismo motor lógico cambiando la semántica (en lugar de "dice verdad/miente" se usa "culpable/inocente"), pero necesitan una modelación ligeramente distinta.

Si quieres que codifique algún ejercicio específico de tu lista (17, 18, 19, 21, 22...), pégame el enunciado y lo agrego.

## Licencia

Proyecto académico para curso de Lógica Proposicional.
