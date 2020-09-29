:- expects_dialect(lps).

% Logic Production Systems

% declarations, initial state, observations, reactive rules, logic programs, causal laws

% Your program goes here

% fluents    emergencia.
maxTime(5).

events    emergencia, alertar_al_conductor.

actions    presione_el_botón.

observe emergencia from 1 to 2.

if emergencia from T1 to T2 then alerte_al_conductor from T2 to T3.
alerte_al_conductor from T1 to T2 if presione_el_botón from T1 to T2.


/** <examples> 
?- go(Timeline).
*/
