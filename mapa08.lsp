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


; mapa08.lsp


; ==============================================================================
;   Descripción:
; ==============================================================================
;
;    En este mapa se muestra como el agente es capaz de explorar la
;   cueva hasta que consiga el objetivo de recoger 4 tesoros. Una vez 
;   cumplido el objetivo abandonará la cueva por la salida más cercana
;
; ==============================================================================
;   Leyenda Mapa
; ==============================================================================
;
; 	M = Muro
; 	_ = Casilla Libre
; 	P = Precipicio
; 	S = Salida

((Tesoro (Posicion (3 3))
	 (Valor 1000))

 (Tesoro (Posicion (6 2))
	 (Valor 1000))

 (Tesoro (Posicion (3 8))
	 (Valor 1000))

 (Tesoro (Posicion (5 6))
	 (Valor 1000))

 (Tesoro (Posicion (8 6))
	 (Valor 1000))

 (Tesoro (Posicion (4 2))
	 (Valor 1000))

 (Wumpus (Nombre Bicho)
	 (Posicion (6 6))
	 (Instinto Territorial)
	 (Movimiento 0.2))

 (BuscaTesoros (Nombre C3PO-1)
	       (Posicion (0 1))	    
	       (TesorosBuscar 4)
	       (MetodoSalida DistanciaMinima))

 (Mapa (M M M M M M M M M M M M)
       (S _ _ _ _ _ _ _ _ _ _ S)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (S _ _ _ _ _ _ _ _ _ _ S)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (S _ _ _ _ _ _ _ _ _ _ S)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (S _ _ _ _ _ _ _ _ _ _ S)
       (M M M M M M M M M M M M)))


; mapa08.lsp