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


; mapa05.lsp


; ==============================================================================
;   Descripci�n:
; ==============================================================================
;
;    Ejemplo de un mapa resoluble f�cilmente con A* en salida.
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

 (Wumpus (Nombre Bicho)
	 (Posicion (1 10)) 
	 (Movimiento 0.1))

 (BuscaTesoros (Nombre C3PO)
	       (Posicion (0 1)))

 (BuscaTesoros (Nombre R2D2)
	       (Forma R)
	       (Posicion (11 10)))

 (Mapa (M M M M M M M M M M M M)
       (M _ _ _ _ _ _ _ _ _ _ S)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ P P _ _ _ _ M)
       (M _ _ _ _ P P _ _ _ _ M)
       (M _ _ _ _ P P _ _ _ _ M)
       (M _ _ _ _ P P _ _ _ _ M)
       (S _ _ _ _ P P _ _ _ _ M)
       (M M M M M M M M M M M M)))


; mapa05.lsp