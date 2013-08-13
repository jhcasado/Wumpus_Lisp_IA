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


; main.lsp


; carga todos los módulos
(load "util.lsp")
(load "ruta.lsp")
(load "entorno.lsp")
(load "buscatesoros.lsp")
(load "wumpus.lsp")
(load "entorno.lsp")


(defun Main-Run (nombreEntorno salto info)
; función principal
; salto = cada cuantos saltos se muestra el resultado
; info = estructuras que visualizaremos. Valores = Mapa InfoBuscaTesoros InfoWumpus, nil
  (let ((entorno (make-StructEntorno)))

    (if (equal info nil) ; si info es nil, visualizamos toda la información
	(setf info '(Mapa InfoBuscaTesoros InfoWumpus)))

    (Entorno-Leer nombreEntorno entorno)

    (loop
      (Entorno-Dibujar entorno salto info)
      (Entorno-Movimientos entorno)
      (Entorno-Actualizar entorno))))


; main.lsp
