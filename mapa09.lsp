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


; mapa09.lsp


; ==============================================================================
;   Descripción:
; ==============================================================================
;
;    El siguiente mapa muestra la gran ventaja que supone usar el 
; algoritmo A* para abandonar la cueva. Si explorando el lugar
; nos encontramos con el Wumpus, la probabilidad de morir es alta
; debido a que el monstruo tiene una capacidad de movimiento del 
; 50% y utiliza el instino asesino.
;
; ==============================================================================
;   Leyenda Mapa
; ==============================================================================
;
; 	M = Muro
; 	_ = Casilla Libre
; 	P = Precipicio
; 	S = Salida

((Tesoro (Posicion (13 3))
	 (Valor 1000))

 (Wumpus (Nombre Bicho)
	 (Posicion (13 1))
	 (Instinto Asesino)
	 (Movimiento 0.5))

 (BuscaTesoros (Nombre C3PO-Aleatorio)
	       (Forma R)
	       (MetodoSalida Aleatorio)
	       (Posicion (0 1)))

 (BuscaTesoros (Nombre C3PO-Estrella)
	       (Forma A)
	       (Posicion (0 1)))

 (Mapa (M M M M M M M M M M M M M M M)
       (M _ _ _ _ _ _ p _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ p _ _ _ _ _ _ M)
       (M _ _ p _ _ _ p _ _ _ p _ _ M)
       (M _ _ p _ _ _ p _ _ _ P _ _ M)
       (M _ _ p _ _ _ p _ _ _ P _ _ M)
       (M _ _ p _ _ _ p _ _ _ P _ _ M)
       (M _ _ p _ _ _ p _ _ _ P _ _ M)
       (M _ _ p _ _ _ p _ _ _ p _ _ M)
       (M _ _ p _ _ _ _ _ _ _ p _ _ M)
       (S _ _ p _ _ _ _ _ _ _ p _ _ M)
       (M M M M M M M M M M M M M M M)))


; mapa09.lsp