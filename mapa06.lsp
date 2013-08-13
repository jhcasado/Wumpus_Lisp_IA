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


; mapa06.lsp


; ==============================================================================
;   Descripción:
; ==============================================================================
;
;    Mapa con varios BuscaTesoros y varios Wumpus.
;
; ==============================================================================
;   Leyenda Mapa
; ==============================================================================
;
; 	M = Muro
; 	_ = Casilla Libre
; 	P = Precipicio
; 	S = Salida

((Tesoro (Posicion (10 1)))

 (Wumpus (Nombre Bicho01)
	 (Posicion (1 10)) 
	 (Movimiento 0.05))

 (Wumpus (Nombre Bicho02)
	 (Posicion (10 2)) 
	 (Movimiento 0.05))

 (BuscaTesoros (Nombre C3PO)
	       (MetodoSalida DistanciaMinima)
	       (Posicion (0 1)))

 (BuscaTesoros (Nombre R2D2)
	       (Forma R)
	       (Posicion (11 10)))

 (Mapa (M M M M M M M M M M M M)
       (M _ _ _ _ P _ _ _ _ _ S)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ P M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M P _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ P _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (S _ _ _ _ P _ _ _ _ _ M)
       (M M M M M M M M M M M M)))


; mapa06.lsp