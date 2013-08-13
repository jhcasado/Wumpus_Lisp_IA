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


; buscatesoros.lsp


(defstruct StructBuscaTesoros

  ; variables de configuración
  nombre                          ; nombre del BuscaTesoros
  posicion                        ; posición del BuscaTesoros (x y)
  (forma 'B)                      ; pinta del BuscaTesoros
  (direccion ESTE)                ; Norte, Sur, Oeste, Este
  (numFlechas 1)                  ; número de flechas disponibles
  (asesino 1.0)                   ; probabilidad de que el BuscaTesoros dispare una flecha
  (valiente 0.0)                  ; probabilidad de atravesar una zona peligrosa
  (espontaneo 0.0)                ; probabilidad de generar una acción espontanea
  (metodoExploracion 'Aleatorio)  ; indica cual es la estrategia que utiliza el agente para buscar el tesoro
                                  ; Valores: Aleatorio
  (mapaExploracion 'Si)           ; usa el mapa durante la exploración
  (metodoSalida 'DistanciaMinimaA); indica cual es método utilizado por el agente para salir del laberinto
                                  ; Valores: Aleatorio, DistanciaMinima, DistanciaMinimaA
  (mapaSalir 'Si)                 ; el agente crea un mapa y lo usa para salir de la cueva
  (tesorosBuscar 1)               ; le indica al BuscaTesoros el número de tesoros que debe buscar para 
                                  ; poder abandonar la cueva
  (maxTurnosBusqueda 50000)       ; máximo número de turnos que se pueden gastar en la búsqueda
  (anchoMapa 15)                  ; ancho máximo del mapa
  (altoMapa 15)                   ; alto máximo del mapa

  ; variables de estado
  (estado 'Vivo)                  ; Muerto, Vivo, Fuera, Tramposo
  (turnos 0)                      ; turnos utilizados para conseguir el objetivo
  (objetivo 'Explorar)            ; indica cual es el objetivo del BuscaTesoros. Valores: Explorar, Salir
  (wumpusMuertos 0)               ; número de Wumpus que ha matado
  listaTesoros                    ; lista con los tesoros recogidos por el BuscaTesoros  
  listaSalidas                    ; posiciones de las posibles salidas ((x1 y1) (x2 y2) ... (xn yn))
  listaTareas                     ; lista de tareas a realizar. 
                                  ; Valores: GirarDerecha, GirarIzquierda, Avanzar, DispararFlecha, 
                                  ;          Saltar, RecogerTesoro
  (flechaDisparada nil)           ; t si acaba de disparar una flecha
  (pasarDeOlor 0)                 ; indica cuantos turnos pasa el agente de mirar el sensor de mal olor
  (retrocediendo 0)               ; número de turnos que se pasa el agente retrocediendo 
  (estadoSensores nil)            ; lista con los sensores que están activos
  mapa)                           ; mapa que se va construyendo el BuscaTesoros


; ------------------------------------------------------------------------------------------------------------------
;  Sensores
; ------------------------------------------------------------------------------------------------------------------


(defun BT-Sensor-Brillo (buscatesoros entorno)
; devuelve t si está en una casilla con el tesoro
  (let ((resultado nil)
	(posBt (StructBuscaTesoros-posicion buscatesoros)))
    (dolist (elto (StructEntorno-listaTesoros entorno) resultado)
      (cond ((equal (StructTesoro-posicion elto) posBt) (setf resultado t))))))


(defun BT-Sensor-Golpe (buscatesoros entorno)
; devuelve t si la pos en
  (if (equal (Entorno-Casilla entorno (Avanzar (StructBuscaTesoros-posicion buscatesoros) 
					       (StructBuscaTesoros-direccion buscatesoros))) 'M) t))


(defun BT-Sensor-Brisa (buscatesoros entorno)
; comprueba si hay una brisa cerca
  (let ((posBt (StructBuscaTesoros-posicion buscatesoros))
	(direcciones `((0 0) ,NORTE ,SUR ,ESTE ,OESTE))
	(resultado nil))

    (dolist (elto direcciones resultado)
      (if (equal (Entorno-Casilla entorno (Avanzar posBt elto)) 'P) (setf resultado t)))))


(defun BT-Sensor-MalOlor (buscatesoros entorno)
; comprueba si hay mal olor
  (let ((posBt (StructBuscaTesoros-posicion buscatesoros))
	(direcciones `((0 0) ,NORTE ,SUR ,ESTE ,OESTE))
	(resultado nil))

    (dolist (wumpus (StructEntorno-listaWumpus entorno) resultado)
      (dolist (elto direcciones resultado)
	(if (equal (StructWumpus-posicion wumpus) (Avanzar posBt elto)) (setf resultado t))))))


(defun BT-Sensor-Grito (buscatesoros entorno)
; devuelve t si hay un grito en la lista
  (if (equal (StructEntorno-listaGritos entorno) nil) nil
    t))


(defun BT-Sensor-Salida (buscatesoros entorno)
; comprueba si se encuentra en una casilla de salida 'S
  (let ((posBt (StructBuscaTesoros-posicion buscatesoros)))
    (if (equal (Entorno-Casilla entorno posBt) 'S) t
      nil)))


(defun BT-Actualizar-Estado-Sensores (buscatesoros entorno)
; actualiza la lista de sensores con los que están activos
  (setf (StructBuscaTesoros-estadoSensores buscatesoros) nil)

  (if (BT-Sensor-Brillo buscatesoros entorno)
      (setf (StructBuscaTesoros-estadoSensores buscatesoros)
	    (Añadir-Elemento (StructBuscaTesoros-estadoSensores buscatesoros) 'BRILLO)))
  
  (if (BT-Sensor-Brisa buscatesoros entorno)
      (setf (StructBuscaTesoros-estadoSensores buscatesoros)
	    (Añadir-Elemento (StructBuscaTesoros-estadoSensores buscatesoros) 'BRISA)))

  (if (BT-Sensor-MalOlor buscatesoros entorno)
      (setf (StructBuscaTesoros-estadoSensores buscatesoros)
	    (Añadir-Elemento (StructBuscaTesoros-estadoSensores buscatesoros) 'MALOLOR)))

  (if (BT-Sensor-Salida buscatesoros entorno)      
      (setf (StructBuscaTesoros-estadoSensores buscatesoros)
	    (Añadir-Elemento (StructBuscaTesoros-estadoSensores buscatesoros) 'SALIDA)))

  (if (BT-Sensor-Grito buscatesoros entorno)
      (setf (StructBuscaTesoros-estadoSensores buscatesoros)
	    (Añadir-Elemento (StructBuscaTesoros-estadoSensores buscatesoros) 'GRITO)))

  (if (BT-Sensor-Golpe buscatesoros entorno)
      (setf (StructBuscaTesoros-estadoSensores buscatesoros)
	    (Añadir-Elemento (StructBuscaTesoros-estadoSensores buscatesoros) 'GOLPE))))


; ------------------------------------------------------------------------------------------------------------------
;  Acciones
; ------------------------------------------------------------------------------------------------------------------


(defun BT-Avanzar (buscatesoros)
; avanza la pos del BuscaTesoros
  (setf (StructBuscaTesoros-posicion buscatesoros) 
	(Avanzar (StructBuscaTesoros-posicion buscatesoros) (StructBuscaTesoros-direccion buscatesoros))))


(defun BT-Girar-Derecha (buscatesoros)
; gira el BuscaTesoros a la derecha
  (setf (StructBuscaTesoros-direccion buscatesoros)
	(Girar-Derecha (StructBuscaTesoros-direccion buscatesoros))))


(defun BT-Girar-Izquierda (buscatesoros)
; gira el BuscaTesoros a la izquierda
  (setf (StructBuscaTesoros-direccion buscatesoros)
	(Girar-Izquierda (StructBuscaTesoros-direccion buscatesoros))))


(defun BT-Recoger-Tesoro (buscatesoros entorno)
; recoge un tesoro. Devuelve t si pudo hacerlo, sino nil
  (let ((posBt (StructBuscaTesoros-posicion buscatesoros))
	(resultado nil))

    (dolist (elto (StructEntorno-listaTesoros entorno) resultado)
      (cond ((equal posBt (StructTesoro-posicion elto))
	     (setf resultado t)
	     (setf (StructEntorno-listaTesoros entorno) (remove elto (StructEntorno-listaTesoros entorno)))
	     (setf (StructBuscaTesoros-listaTesoros buscatesoros)
		   (Añadir-Elemento (StructBuscaTesoros-listaTesoros buscatesoros) elto)))))))


(defun BT-Saltar (buscatesoros entorno)
; sale fuera de la cueva
  (let ((posBt (StructBuscaTesoros-posicion buscatesoros))
	(resultado nil))

    (cond ((equal (Entorno-Casilla entorno posBt) 'S) ; comprueba si está en una pos de salida
	   (setf (StructBuscaTesoros-estado buscatesoros) 'Fuera)
	   (setf resultado t)))
    resultado))


(defun BT-Disparar-Flecha (buscatesoros entorno) 
; dispara una flecha, si tiene
  (cond ((>= (StructBuscaTesoros-numFlechas buscatesoros) 1)
	 (setf (StructBuscaTesoros-flechaDisparada buscatesoros) t)
	 (Entorno-Disparar-Flecha entorno buscatesoros))
	(t nil)))


; ------------------------------------------------------------------------------------------------------------------
;  Funciones para gestionar el mapa que va generando el agente
; ------------------------------------------------------------------------------------------------------------------


(defun BT-Dibujar-Mapa (buscatesoros)
; dibuja el mapa
  (let ((posMapa nil))

  (dotimes (y (length (StructBuscaTesoros-mapa buscatesoros)))
    (format t " ~%  ->")
    (dotimes (x (length (nth y (StructBuscaTesoros-mapa buscatesoros))))
      (setf posMapa (list x (- (length (StructBuscaTesoros-mapa buscatesoros)) y 1)))
      (format t " ~S" (nth x (nth y (StructBuscaTesoros-mapa buscatesoros)))))))
 t)


(defun BT-Rellenar-Mapa-Inicial (buscatesoros)
; rellana a '? todo el mapa
  (dotimes (y (StructBuscaTesoros-altoMapa buscatesoros))
    (setf (StructBuscaTesoros-mapa buscatesoros) (cons nil (StructBuscaTesoros-mapa buscatesoros))))

  (dotimes (y (StructBuscaTesoros-altoMapa buscatesoros))
    (dotimes (x (StructBuscaTesoros-anchoMapa buscatesoros))
      (setf (nth y (StructBuscaTesoros-mapa buscatesoros))
	    (Añadir-Elemento (nth y (StructBuscaTesoros-mapa buscatesoros)) '(?)))))
  t)


(defun BT-Rellenar-Mapa (buscatesoros posicion valor)
; rellena una "posicion" del mapa con "valor"
  (cond ((and (equal (StructBuscaTesoros-objetivo buscatesoros) 'Explorar)
	      (equal (StructBuscaTesoros-mapaExploracion buscatesoros) 'Si))
	 (Modificar-Casilla (StructBuscaTesoros-mapa buscatesoros) posicion valor))

	((and (equal (StructBuscaTesoros-objetivo buscatesoros) 'Salir)
	      (equal (StructBuscaTesoros-mapaSalir buscatesoros) 'Si))
	 (Modificar-Casilla (StructBuscaTesoros-mapa buscatesoros) posicion valor))))


; ------------------------------------------------------------------------------------------------------------------
;  Funciones para gestionar las diferentes acciones del BuscaTesoros dentro de la cueva
; ------------------------------------------------------------------------------------------------------------------


(defun BT-Actualizar-Objetivos (buscatesoros)
; actualiza los objetivos del agente
  (if (and (or (>= (StructBuscatesoros-turnos buscatesoros) ; superamos el máximo de turnos
		   (StructBuscatesoros-maxTurnosBusqueda buscatesoros))
	       (>= (length (StructBuscatesoros-listaTesoros buscatesoros)) ; o hemos conseguido el\los tesoro\s
		   (StructBuscatesoros-tesorosBuscar buscatesoros)))
	   (not (equal (StructBuscatesoros-listaSalidas buscatesoros) nil))) ; y hemos encontrado la salida
      (setf (StructBuscaTesoros-objetivo buscatesoros) 'Salir))) ; cambiamos el objetivo


(defun BT-Generar-Tareas (buscatesoros entorno)
; genera las tareas
  (let ((pos (StructBuscaTesoros-posicion buscatesoros))
	(dir (StructBuscaTesoros-direccion buscatesoros))
	(mapa (StructBuscaTesoros-mapa buscatesoros)))
					    
    (cond ((equal (StructBuscaTesoros-listaTareas buscatesoros) nil) ; sólo si no tenemos tareas pendientes	    

	   (cond ((equal (StructBuscaTesoros-objetivo buscatesoros) 'Explorar) ; objetivo  = Explorar
		  (cond ((equal (StructBuscaTesoros-metodoExploracion buscatesoros) 'Aleatorio) ; método = Aletorio
			 (setf (StructBuscaTesoros-listaTareas buscatesoros) 
			       (Ir-A-Aleatorio mapa pos dir
					       (StructBuscaTesoros-mapaExploracion buscatesoros) 
					       nil)))))

		 ((equal (StructBuscaTesoros-objetivo buscatesoros) 'Salir) ; objetivo = Salir
		  (cond ((equal (StructBuscaTesoros-metodoSalida buscatesoros) 'Aleatorio) ; método = Aleatorio 
			 (setf (StructBuscaTesoros-listaTareas buscatesoros) 
			       (Ir-A-Aleatorio mapa pos dir
					       (StructBuscaTesoros-mapaExploracion buscatesoros)
					       nil)))

                        ; método = DistanciaMinimaA		      
			((equal (StructBuscaTesoros-metodoSalida buscatesoros) 'DistanciaMinimaA)
			 (setf (StructBuscaTesoros-listaTareas buscatesoros)
			       (RT-Ruta pos dir
					(RT-Salida-Cercana pos (StructBuscaTesoros-listaSalidas buscatesoros))
					mapa)))

		      ; método = DistanciaMinima
		      ((equal (StructBuscaTesoros-metodoSalida buscatesoros) 'DistanciaMinima)
		     
		       (setf (StructBuscaTesoros-listaTareas buscatesoros)
			     (RT-Distancia-Minima pos dir 
						  (RT-Salida-Cercana pos (StructBuscaTesoros-listaSalidas buscatesoros))))

		       ))))))))


(defun BT-Test-Brisa (buscatesoros entorno)
; generamos las tareas necesarias para responder al sensor de brisa
  (let ((tarea (first (StructBuscaTesoros-listaTareas buscatesoros))))
    
    (cond ((BT-Sensor-Brisa buscatesoros entorno) ; miramos el sensor	  
	   (BT-Rellenar-Mapa buscatesoros (StructBuscaTesoros-posicion buscatesoros) '~)
	   (cond ((and (= (StructBuscaTesoros-retrocediendo buscatesoros) 0)
		       (or (not (equal (StructBuscaTesoros-objetivo buscatesoros) 'Salir))
			   (not (equal (StructBuscaTesoros-metodoSalida buscatesoros) 'DistanciaMinimaA))))
                  ; retrocedemos
		  (setf (StructBuscaTesoros-listaTareas buscatesoros) RETROCEDER)

                  ; colocamos el número de turnos que vamos a estar retrocediendo
		  (setf (StructBuscaTesoros-retrocediendo buscatesoros) 3)))))))


(defun BT-Test-MalOlor (buscatesoros entorno)
; generamos las tareas necesarias para "huir" del Wumpus
  (cond ((BT-Sensor-MalOlor buscatesoros entorno) ; test de malOlor
	 (cond ((and (>= (StructBuscaTesoros-numFlechas buscatesoros) 1)            ; si tenemos flechas, 
		     (> (StructBuscaTesoros-asesino buscatesoros) (NumAleatorio))   ; estamos de humor
		     (not (StructBuscaTesoros-flechaDisparada buscatesoros)))       ; y no es la última acción
		(setf (StructBuscaTesoros-listaTareas buscatesoros)                 ; disparamos
		      (Añadir-Elemento (StructBuscaTesoros-listaTareas buscatesoros)
				       'DispararFlecha)))
	       ((= (StructBuscaTesoros-pasarDeOlor buscatesoros) 0)

		; retrocedemos y generamos una pos aleatoria
		(setf (StructBuscaTesoros-listaTareas buscatesoros) RETROCEDER)

		; colocamos el número de turnos que vamos a pasar de mirar el sensor
		(setf (StructBuscaTesoros-pasarDeOlor buscatesoros) 3))))))


(defun BT-Test-Golpe (buscatesoros entorno)
; comprueba si tenemos un muro delante
  (let ((tarea (first (StructBuscaTesoros-listaTareas buscatesoros))))
  
    (cond ((BT-Sensor-Golpe buscatesoros entorno) ; test de Golpe
           ; rellenamos el mapa con M 
	   (BT-Rellenar-Mapa buscatesoros (Avanzar (StructBuscaTesoros-posicion buscatesoros) 
						   (StructBuscaTesoros-direccion buscatesoros)) 'M)
	   (cond ((equal tarea 'Avanzar)
                  ; nos movemos a una pos aleatoria
		  (setf (StructBuscaTesoros-listaTareas buscatesoros) 
			(Ir-A-Aleatorio (StructBuscaTesoros-mapa buscatesoros) 
					(StructBuscaTesoros-posicion buscatesoros)
					(StructBuscaTesoros-direccion buscatesoros)
					(StructBuscaTesoros-mapaExploracion buscatesoros)
					(StructBuscaTesoros-direccion buscatesoros)))))))))


(defun BT-Test-Salida (buscatesoros entorno)
; comprueba si el agente se encuentra en una casilla de salida
  (cond ((BT-Sensor-Salida buscatesoros entorno) ; test de Salida

	 ; si no la tenemos la añadimos
	 (if (not (Esta (StructBuscaTesoros-listaSalidas buscatesoros)
			(StructBuscaTesoros-posicion buscatesoros)))
	     (setf (StructBuscaTesoros-listaSalidas buscatesoros) 
		   (cons (StructBuscaTesoros-posicion buscatesoros)
			 (StructBuscaTesoros-listaSalidas buscatesoros))))

	 ; si nuestro objetivo es salir -> saltamos
	 (if (equal (StructBuscatesoros-objetivo buscatesoros) 'Salir)
	     (setf (StructBuscaTesoros-listaTareas buscatesoros) 
		   (Añadir-Elemento (StructBuscaTesoros-listaTareas buscatesoros) 'Saltar))))))


(defun BT-Test-Brillo (buscatesoros entorno)
; coge el tesoro, si puede
  (cond ((BT-Sensor-Brillo buscatesoros entorno) ; test de brillo
	 (setf (StructBuscaTesoros-listaTareas buscatesoros) 
	       '(RecogerTesoro)))))


(defun BT-Test-Grito (buscatesoros entorno)
; compuebe si hay algún grito
  (if (BT-Sensor-Grito buscatesoros entorno) ; miramos si nos podemos anotar un tanto
      (dolist (elto (StructEntorno-listaGritos entorno))

	; si algún grito lleva nuestro nombre, nos anotamos un Wumpus muerto :)
	(if (equal elto (StructBuscaTesoros-nombre buscatesoros))
	    (setf (StructBuscaTesoros-wumpusMuertos buscatesoros)
		  (+ (StructBuscaTesoros-wumpusMuertos buscatesoros) 1))))))


(defun BT-Test-Espontaneo (buscatesoros entorno)
; comprueba si podemos generar una acción aleatoria
  (let ((tarea nil)
	(valor nil))

    (cond ((and (> (StructBuscaTesoros-espontaneo buscatesoros) (NumAleatorio))
		(not (BT-Sensor-Golpe buscatesoros entorno)))
	   (if (> (StructBuscaTesoros-valiente buscatesoros) (NumAleatorio))
	       (setf valor (StructBuscaTesoros-mapaExploracion buscatesoros))
	     (setf valor 'Volver))

	   ; añade a la lista de tareas la nueva acción
	   (setf (StructBuscaTesoros-listaTareas buscatesoros)
		 (Ir-A-Aleatorio (StructBuscaTesoros-mapa buscatesoros)
				 (StructBuscaTesoros-posicion buscatesoros)
				 (StructBuscaTesoros-direccion buscatesoros)
				 valor
				 nil))))))


(defun BT-Mirar-Sensores (buscatesoros entorno)
; función que mira todos los sensores
  (let ((pos (StructBuscaTesoros-posicion buscatesoros)))
    
    (BT-Actualizar-Estado-Sensores buscatesoros entorno)

    ; comprobamos los diferentes sensores
    (BT-Test-MalOlor buscatesoros entorno)
    (BT-Test-Golpe buscatesoros entorno)
    (BT-Test-Brisa buscatesoros entorno)
    (BT-Test-Espontaneo buscatesoros entorno)
    (BT-Test-Salida buscatesoros entorno)
    (BT-Test-Grito buscatesoros entorno)
    (BT-Test-Brillo buscatesoros entorno)

    ; si no acabamos de disparar una flecha, ponemos el flag, flechaDisparada, a nil
    (if (not (equal (first (StructBuscaTesoros-listaTareas buscatesoros)) 'DispararFlecha))
	(setf (StructBuscaTesoros-flechaDisparada buscatesoros) nil))

    ; decrementamos el número de turnos que pasamos de mirar el sensor de malOlor
    (if (> (StructBuscaTesoros-pasarDeOlor buscatesoros) 0)
	(setf (StructBuscaTesoros-pasarDeOlor buscatesoros) 
	      (- (StructBuscaTesoros-pasarDeOlor buscatesoros) 1)))

    ; decrementamos el número de turnos que estamos retrocediendo
    (if (> (StructBuscaTesoros-retrocediendo buscatesoros) 0)
	(setf (StructBuscaTesoros-retrocediendo buscatesoros)
	      (- (StructBuscaTesoros-retrocediendo buscatesoros) 1)))))


(defun BT-Ejecutar-Movimiento (buscatesoros entorno)
; ejecuta una tarea de la lista de tareas
  (let ((tarea (first (StructBuscaTesoros-listaTareas buscatesoros))))
    
    (cond ((equal tarea 'Avanzar) ; avanza
	   (BT-Avanzar buscatesoros))

	  ((equal tarea 'GirarDerecha) ; gira a la derecha
	   (BT-Girar-Derecha buscatesoros))

	  ((equal tarea 'GirarIzquierda) ; gira a la izquierda
	   (BT-Girar-Izquierda buscatesoros))

	  ((equal tarea 'RecogerTesoro) ; recoge el tesoro
	   (BT-Recoger-Tesoro buscatesoros entorno))

	  ((equal tarea 'Saltar) ; sale de la cueva
	   (BT-Saltar buscatesoros entorno))

	  ((equal tarea 'DispararFlecha) ; dispara la flecha
	   (BT-Disparar-Flecha buscatesoros entorno))

	  (t (print 'ERROR-TAREA-DESCONOCIDA))) ; útil para depurar

    (setf (StructBuscaTesoros-listaTareas buscatesoros)
	  (rest (StructBuscaTesoros-listaTareas buscatesoros)))))


(defun BT-Movimiento (buscatesoros entorno)
; efectua el movimiento del agente BuscaTesoros según su configuración
  (BT-Rellenar-Mapa buscatesoros (StructBuscaTesoros-posicion buscatesoros) '_)
  (BT-Generar-Tareas buscatesoros entorno)
  (BT-Mirar-Sensores buscatesoros entorno)
  (BT-Ejecutar-Movimiento buscatesoros entorno)
  (BT-Actualizar-Objetivos buscatesoros))


; buscatesoros.lsp