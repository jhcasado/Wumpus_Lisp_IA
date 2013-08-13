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


; mapa00.lsp


; ==============================================================================
;   Descripci�n:
; ==============================================================================
;
;    Ejemplo sencillo de un mapa de 5x5 con un BuscaTesoros.
;
; ==============================================================================
;   Leyenda Mapa
; ==============================================================================
;
; 	M = Muro
; 	_ = Casilla Libre
; 	P = Precipicio
; 	S = Salida

((Tesoro (Posicion (3 3)))

 (BuscaTesoros (Nombre C3PO)
	       (Posicion (0 1)))

 (Mapa (M M M M M)
       (M _ _ _ M)
       (M _ _ _ M)
       (S _ _ _ M)
       (M M M M M)))


; mapa00.lsp