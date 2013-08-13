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


; mapa02.lsp


; ==============================================================================
;   Descripción:
; ==============================================================================
;
;    Ejemplo sencillo de un mapa de 8x8 con un BuscaTesoros y con
;   un Wumpus un poco lento.
;
; ==============================================================================
;   Leyenda Mapa
; ==============================================================================
;
; 	M = Muro
; 	_ = Casilla Libre
; 	P = Precipicio
; 	S = Salida

((Tesoro (Posicion (6 6)))

 (BuscaTesoros (Nombre C3PO)
	       (Posicion (0 1)))

 (Wumpus (Nombre Bicho)
	 (Posicion (6 1)) 
	 (Movimiento 0.05))

 (Mapa (M M M M M M M M)
       (M _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ M)
       (S _ _ _ _ _ _ M)
       (M M M M M M M M)))


; mapa02.lsp