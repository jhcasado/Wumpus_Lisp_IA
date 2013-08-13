; ==============================================================================
;	
;	El mundo de Wumpus
;	Versión: 1.0.0b
;
;	Javier Honorio Casado Fernández

;	
;	José Ángel Montelongo Reyes

;
;	Universidad de las Palmas de Gran Canaria	
;
; ==============================================================================


; mapa10.lsp


; ==============================================================================
;   Descripción:
; ==============================================================================
;
;    El siguiente mapa muestra a tres agentes, donde cada uno 
; utiliza un algoritmo diferente para abandonar la cueva. Cada 
; agente explorará un nº determinados de turnos y posteriormente 
; regresará.
;
; ==============================================================================
;   Leyenda Mapa
; ==============================================================================
;
; 	M = Muro
; 	_ = Casilla Libre
; 	P = Precipicio
; 	S = Salida

((BuscaTesoros (Nombre C3PO-Aleatorio)
	       (maxTurnosBusqueda 500)  
	       (Forma R)
	       (MetodoSalida Aleatorio)
	       (Posicion (0 1)))

 (BuscaTesoros (Nombre C3PO-DM)
	       (maxTurnosBusqueda 500)  
	       (Forma D)
	       (MetodoSalida DistanciaMinima)
	       (Posicion (0 1)))

 (BuscaTesoros (Nombre C3PO-Estrella)
	       (maxTurnosBusqueda 500)
	       (Forma A)
	       (Posicion (0 1)))

 (Mapa (M M M M M M M M M M M M M M M)
       (M P _ _ _ _ p _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ p _ _ _ _ _ _ _ p _ M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ p _ _ _ _ _ _ M)
       (M P P _ _ _ _ _ _ _ _ _ _ p M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ p _ _ _ M)
       (M _ _ _ P _ _ _ _ _ _ _ _ _ M)
       (S _ _ _ P _ p _ _ _ _ P _ _ M)
       (M M M M M M M M M M M M M M M)))


; mapa10.lsp