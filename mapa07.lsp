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


; mapa07.lsp


; ==============================================================================
;   Descripción:
; ==============================================================================
;
;    Mapa con tres Wumpus que poseen tres algoritmos de 
;   comportamiento diferentes.
;
; ==============================================================================
;   Leyenda Mapa
; ==============================================================================
;
; 	M = Muro
; 	_ = Casilla Libre
; 	P = Precipicio
; 	S = Salida

((Tesoro (Posicion (8 6))
	 (Valor 5000))

 (Wumpus (Nombre Bicho-Aleatorio)
	 (Forma A)
	 (Posicion (8 1)) 
	 (Instinto Aleatorio))

 (Wumpus (Nombre Bicho-Asesino)
	 (Forma M)
	 (Posicion (9 1)) 
	 (Instinto Asesino))

 (Wumpus (Nombre Bicho-Territorial)
	 (Forma S)
	 (Posicion (10 1)) 
	 (Instinto Territorial))

 (BuscaTesoros (Nombre C3PO)
	       (Posicion (0 1)))

 (Mapa (M M M M M M M M M M M M)
       (M P _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ P _ _ _ _ _ M)
       (M _ _ _ _ P _ _ _ _ P M)
       (M _ _ _ _ P _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M P _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (S _ _ _ _ P _ _ _ _ _ M)
       (M M M M M M M M M M M M)))


; mapa07.lsp