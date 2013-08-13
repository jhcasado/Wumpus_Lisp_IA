; ==============================================================================
;	
;	El mundo de Wumpus
;	Versi�n: 1.0.0b
;
;	Javier Honorio Casado Fern�ndez

;	
;	Jos� �ngel Montelongo Reyes

;
;	Universidad de las Palmas de Gran Canaria	
;
; ==============================================================================


; mapa11.lsp


; ==============================================================================
;   Descripci�n:
; ==============================================================================
;
;    El siguiente mapa muestra a tres agentes, donde cada uno 
;   utiliza un algoritmo diferente para abandonar la cueva. Cada 
;   agente explorar� un n� determinados de turnos y posteriormente 
;   regresar�, en esta versi�n no exiten obstaculos.
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
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (S _ _ _ _ _ _ _ _ _ _ _ _ _ M)
       (M M M M M M M M M M M M M M M)))


; mapa11.lsp