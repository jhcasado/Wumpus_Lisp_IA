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


; mapa04.lsp


; ==============================================================================
;   Descripci�n:
; ==============================================================================
;
;    Ejemplo de un mapa que nos es capaz de atravezar nuestro 
;   agente debido a que los precipicios est�n demasiado cerca.
;   Si a�adimos el atributo valiente con un valor alto, exista la
;   posibilidad de que el agente de con el tesoro. Otra posibilidad
;   es la detectar los precipicios en el mapa que vamos generando.
;
; ==============================================================================
;   Leyenda Mapa
; ==============================================================================
;
; 	M = Muro
; 	_ = Casilla Libre
; 	P = Precipicio
; 	S = Salida

((Tesoro (Posicion (7 8)))

 (BuscaTesoros (Nombre C3PO)
	       (Posicion (0 1 )))

 (Mapa (M M M M M M M M M M M M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ P _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ P _ _ _ _ _ M)
       (M _ _ _ _ _ _ _ _ _ _ M)
       (M _ _ _ _ P _ _ _ _ _ M)
       (S _ _ _ _ _ _ _ _ _ _ M)
       (M M M M M M M M M M M M)))


; mapa04.lsp