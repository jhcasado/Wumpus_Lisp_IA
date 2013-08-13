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


; mapa03.lsp


; ==============================================================================
;   Descripción:
; ==============================================================================
;
;    Ejemplo sencillo de un mapa de 12x12 con un BuscaTesoros y un
; Wumpus hiperactivo.
;
; ==============================================================================
; Leyenda Mapa
; ==============================================================================
;
; 	M = Muro
; 	_ = Casilla Libre
; 	P = Precipicio
; 	S = Salida

((Tesoro (Posicion (7 10)))

 (Wumpus (Nombre Roberto-Carlos)
	 (Posicion (1 10)) 
	 (Movimiento 1.0))

 (BuscaTesoros (Nombre C3PO)
	       (Posicion (0 1)))

 (Mapa (M M M M M M M M M M M M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M P _ _ _ P _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (S _ _ _ _ P _ _ _ _ _ M)
       (M M M M M M M M M M M M)))


; mapa03.lsp