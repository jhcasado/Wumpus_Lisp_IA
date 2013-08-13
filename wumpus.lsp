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


; wumpus.lsp


(defstruct StructWumpus

  ; variables de configuración
  nombre                 ; nombre del Wumpus
  posicion               ; posición del Wumpus (x y)
  (forma 'W)             ; pinta del Wumpus
  (direccion NORTE)      ; Norte, Sur, Oesto, Este
  (movimiento 0.15)      ; probalidad de realizar un movimiento (0.0 => no se mueve nunca, 1.0 => se mueve siempre)
  (instinto 'Aleatorio)  ; indica como de comporta el Wumpus. Valores: Aleatorio, Territorial, Asesino
  (radioOido 4)          ; indica el número de casillas en las cuales el Wumpus es capaz de oír al BuscaTesoros
  (radioTerritorio 3)    ; radio del territorio del Wumpus

  ; variables de estado
  (estado 'Vivo)         ; Valores: Muerto, Vivo
  (origen nil)           ; posición inicial del Wumpus
  (listaTareas nil))     ; lista de tareas pendientes. 
                         ; Valores: Avanzar, GirarDerecha, GirarIzquierda


(defun Wumpus-Avanzar (wumpus)
; avanza la pos actual del wumpus una pos en la dir que está colocado
  (setf (StructWumpus-posicion wumpus) 
	(Avanzar (StructWumpus-posicion wumpus) (StructWumpus-direccion wumpus))))


(defun Wumpus-Girar-Derecha (wumpus)
; gira el wumpus a la derecha
  (setf (StructWumpus-direccion wumpus)
	(Girar-Derecha (StructWumpus-direccion wumpus))))


(defun Wumpus-Girar-Izquierda (wumpus)
; gira el wumpus a la iquierda
  (setf (StructWumpus-direccion wumpus)
	(Girar-Izquierda (StructWumpus-direccion wumpus))))


(defun Wumpus-Mirar (wumpus entorno)
; mira que casilla tiene delante el wumpus
  (Entorno-Casilla entorno (Avanzar (StructWumpus-posicion wumpus) 
				    (StructWumpus-direccion wumpus))))


(defun Wumpus-Ejecutar-Movimiento (wumpus entorno)
; ejecuta una tarea de la lista de tareas
  (let ((tarea (first (StructWumpus-listaTareas wumpus))))
    
    (cond ((equal tarea 'Avanzar) ; avanza
	   (Wumpus-Avanzar wumpus))
	  
	  ((equal tarea 'GirarDerecha) ; gira a la derecha
	   (Wumpus-Girar-Derecha wumpus))

	  ((equal tarea 'GirarIzquierda) ; gira a la izquierda
	   (Wumpus-Girar-Izquierda wumpus))
	  
	  (t (print 'ERROR-TAREA-DESCONOCIDA))) ; útil para depurar

    (setf (StructWumpus-listaTareas wumpus)
	  (rest (StructWumpus-listaTareas wumpus)))))


(defun Wumpus-Movimiento-Aleatorio (wumpus entorno)
; realiza un movimiento aleatorio
; probabilidades:
;    Girar-Derecha = 0.25
;    Girar-Izquierda = 0.25
;    Avanzar = 0.5
  (let ((movimiento 0)
	(limite 0)
	(casilla '_))

    (setf casilla (Wumpus-Mirar wumpus entorno))
    (cond ((equal casilla '_) (setf limite 2))
	  ((equal casilla 'P) (setf limite 2)))
    (setf movimiento (random (+ 2 limite)))
    (cond ((= movimiento 0) (Wumpus-Girar-Derecha wumpus))
	  ((= movimiento 1) (Wumpus-Girar-Izquierda wumpus)) 
	  ((= movimiento 2) (Wumpus-Avanzar wumpus))
	  ((= movimiento 3) (Wumpus-Avanzar wumpus)))))


(defun Wumpus-Movimiento-Territorial (wumpus entorno)
; realiza el movimiento territorial del Wumpus
  (cond ((equal (StructWumpus-listaTareas wumpus) nil)
	 (Wumpus-Movimiento-Aleatorio wumpus entorno)
	 (if (>= (Distancia (StructWumpus-origen wumpus) (StructWumpus-posicion wumpus))
		 (StructWumpus-radioTerritorio wumpus))
	     (setf (StructWumpus-listaTareas wumpus) RETROCEDER)))
	(t (Wumpus-Ejecutar-Movimiento wumpus entorno))))


(defun Wumpus-Movimiento-Asesino (wumpus entorno)
; realiza el movimiento del Wumpus asesino
  (cond ((equal (StructWumpus-listaTareas wumpus) nil)
	 (Wumpus-Movimiento-Aleatorio wumpus entorno)
	 (dolist (bt (StructEntorno-listaBuscaTesoros entorno))
	   (if (and (<= (Distancia (StructBuscaTesoros-posicion bt) 
				   (StructWumpus-posicion wumpus))
			(StructWumpus-radioOido wumpus))
		    (equal (StructBuscaTesoros-estado bt) 'Vivo))	      
	       (setf (StructWumpus-listaTareas wumpus) ; nos movemos a la casilla más cercana
		     (RT-Distancia-Minima (StructWumpus-posicion wumpus)
					  (StructWumpus-direccion wumpus) 
					  (StructBuscatesoros-posicion bt))))))
	(t (Wumpus-Ejecutar-Movimiento wumpus entorno))))


(defun Wumpus-Movimiento (wumpus entorno)
; función principal que controla los movimientos de Wumpus
  (if (> (StructWumpus-movimiento wumpus) (NumAleatorio))
      (cond ((equal (StructWumpus-instinto wumpus) 'Aleatorio) ; movimiento: Aleatorio
	     (Wumpus-Movimiento-Aleatorio wumpus entorno))
	    ((equal (StructWumpus-instinto wumpus) 'Asesino) ; movimiento: Asesino
	     (Wumpus-Movimiento-Asesino wumpus entorno))
	    ((equal (StructWumpus-instinto wumpus) 'Territorial) ; movimiento: Territorial
	     (Wumpus-Movimiento-Territorial wumpus entorno)))))


; wumpus.lsp
