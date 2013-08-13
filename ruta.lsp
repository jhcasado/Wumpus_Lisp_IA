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


; ruta.lsp


(defstruct StructRuta
  (ABIERTA nil)    ; lista ABIERTA
  (CERRADA nil))   ; lista CERRADA

; Estructura de una trayectoria:
; trayectoria = (f*(n) g (n) h*(n) (x1 y1) (x2 y2) ... (xn yn))  
; f*(n) = coste total estimado
; g (n) = coste acumulado
; h*(n) = coste estimado


; ------------------------------------------------------------------------------------------------------------------
;  Funciones para generar rutas
; ------------------------------------------------------------------------------------------------------------------


(defun Ir-A (posActual direccion destino)
; calcula las tareas necesarias para ir de "posActual" a "destino" apuntando a "direccion"
  (let ((caso (list (- (first destino) (first posActual))
		    (- (second destino) (second posActual)))))

    (cond ((> (Distancia-Entero posActual destino) 1) nil)
	  ((equal caso '(0 0)) nil)
	  ((equal caso '(-1 0)) (cond ((equal direccion NORTE) '(GirarIzquierda Avanzar))
				      ((equal direccion ESTE) '(GirarIzquierda GirarIzquierda Avanzar))
				      ((equal direccion SUR) '(GirarDerecha Avanzar))
				      ((equal direccion OESTE) '(Avanzar))))

	  ((equal caso '(-1 1)) (cond ((equal direccion NORTE) '(Avanzar GirarIzquierda Avanzar))
				      ((equal direccion ESTE) '(GirarIzquierda Avanzar GirarIzquierda Avanzar))
				      ((equal direccion SUR) '(GirarDerecha Avanzar GirarDerecha Avanzar))
				      ((equal direccion OESTE) '(Avanzar GirarDerecha Avanzar))))

	  ((equal caso '(0 1)) (cond ((equal direccion NORTE) '(Avanzar))
				     ((equal direccion ESTE) '(GirarIzquierda Avanzar))
				     ((equal direccion SUR) '(GirarIzquierda GirarIzquierda Avanzar))
				     ((equal direccion OESTE) '(GirarDerecha Avanzar))))

	  ((equal caso '(1 1)) (cond ((equal direccion NORTE) '(Avanzar GirarDerecha Avanzar))
				     ((equal direccion ESTE) '(Avanzar GirarIzquierda Avanzar))
				     ((equal direccion SUR) '(GirarIzquierda Avanzar GirarIzquierda Avanzar))
				     ((equal direccion OESTE) '(GirarDerecha Avanzar GirarDerecha Avanzar))))

	  ((equal caso '(1 0)) (cond ((equal direccion NORTE) '(GirarDerecha Avanzar))
				     ((equal direccion ESTE) '(Avanzar))
				     ((equal direccion SUR) '(GirarIzquierda Avanzar))
				     ((equal direccion OESTE) '(GirarIzquierda GirarIzquierda Avanzar))))

	  ((equal caso '(1 -1)) (cond ((equal direccion NORTE) '(GirarDerecha Avanzar GirarDerecha Avanzar))
				      ((equal direccion ESTE) '(Avanzar GirarDerecha Avanzar))
				      ((equal direccion SUR) '(Avanzar GirarIzquierda Avanzar))
				      ((equal direccion OESTE) '(GirarIzquierda Avanzar GirarIzquierda Avanzar))))

	  ((equal caso '(0 -1)) (cond ((equal direccion NORTE) '(GirarIzquierda GirarIzquierda Avanzar))
				      ((equal direccion ESTE) '(GirarDerecha Avanzar))
				      ((equal direccion SUR) '(Avanzar))
				      ((equal direccion OESTE) '(GirarIzquierda Avanzar))))

	  ((equal caso '(-1 -1)) (cond ((equal direccion NORTE) '(GirarIzquierda Avanzar GirarIzquierda Avanzar))
				       ((equal direccion ESTE) '(GirarDerecha Avanzar GirarDerecha Avanzar))
				       ((equal direccion SUR) '(Avanzar GirarDerecha Avanzar))
				       ((equal direccion OESTE) '(Avanzar GirarIzquierda Avanzar)))))))


(defun Pos-Aleatorio (mapa posActual direccion lista valor1 valor2)
; genera una pos aleatoria
  (let ((posExplorar nil)
	(casilla nil))

    (if (not (equal lista nil)) ; cogemos una pos de la lista
	(setf posExplorar (nth (random (length lista)) lista)))

    (if (or (equal (Mapa-Casilla mapa (Avanzar posActual direccion)) valor1)
	    (equal (Mapa-Casilla mapa (Avanzar posActual direccion)) valor2))
	(setf posExplorar direccion)) ; si la casilla que apunta "direccion"
                                      ; "coincide" con "valor", la pos es buena

    (if (not (equal posExplorar nil)) ; miramos la casilla que apunta "posExplorar"
	(setf casilla (Mapa-Casilla mapa (Avanzar posActual posExplorar))))

    (if (or (equal casilla valor1) ; si la casilla contiene el valor deseado
	    (equal casilla valor2)
	    (equal lista nil))    ; o la lista está vacía
	posExplorar               ; devolvemos posExplorar
      (Pos-Aleatorio mapa posActual direccion (Eliminar-Elemento lista posExplorar) valor1 valor2))))


(defun Ir-A-Aleatorio (mapa posActual direccion mirarMapa posSig)
; devuelve la lista de tareas para ir a una pos aleatoria
  (let ((posExplorar nil)
	(dirAleatoria nil)
	(casosPosibles `(,NORTE ,ESTE ,SUR ,OESTE))
	(casos nil))

    ; eliminamos la posSig
    (dolist (elto casosPosibles)
      (if (not (equal elto posSig))
	  (setf casos (cons elto casos))))

    ; generamos una pos aleatoria
    (setf dirAleatoria (nth (random (length casosPosibles)) casosPosibles))
	  
    ; hacemos uso del mapa
    (setf posExplorar (Pos-Aleatorio mapa posActual direccion casos '? '?))
    (if (equal posExplorar nil)
	(setf posExplorar (Pos-Aleatorio mapa posActual dirAleatoria casos '_ '~)))    

    ; generamos una pos segura
    (if (equal mirarMapa 'Volver)
	(setf posExplorar (Pos-Aleatorio mapa posActual dirAleatoria casos '_ '_)))

    ; no miramos el mapa
    (if (or (equal mirarMapa 'No) 
	    (equal posExplorar nil))
	(setf posExplorar (nth (random (length casos)) casos)))

    (Ir-A posActual direccion (list (+ (first posExplorar) (first posActual))
				    (+ (second posExplorar) (second posActual))))))


(defun RT-Distancia-Minima (origen direccion destino)
; devuelve la lista de tareas que llevan al agente a la pos más cercana a un destino
  (let ((casos `(,ESTE ,SUR ,OESTE))
	(minDist nil))

    (setf minDist (Avanzar origen NORTE))

    (dolist (elto casos)
      (if (<= (Distancia (Avanzar origen elto) destino) (Distancia MinDist destino))
	  (setf minDist (Avanzar origen elto))))

    (Ir-A origen direccion minDist)))


(defun RT-Salida-Cercana (posActual lista)
; devuelve la salida más cercana
(let ((salida (first lista)))

  (dolist (elto lista salida)
    (if (< (Distancia posActual elto) 
	   (Distancia posActual salida))
	(setf salida elto)))))


; ------------------------------------------------------------------------------------------------------------------
;  Funciones para la implementación del algoritmo A*
; ------------------------------------------------------------------------------------------------------------------


(defun RT-Crear-Grafo-Inicial (dimension)
; crea el grafo vacio
  (let ((grafo nil))

    (dotimes (y (second dimension))
      (setf grafo (cons nil grafo)))
    
    (dotimes (y (second dimension))
      (dotimes (x (first dimension))
	(setf (nth y grafo) (Añadir-Elemento (nth y grafo) '(M)))))
    grafo))


(defun RT-Generar-Grafo (posActual posSalida mapa)
; rellena el grafo de la forma: (coste costeEstimado)
  (let ((grafo (RT-Crear-Grafo-Inicial (list (length (first mapa)) (length mapa)))))
        
    (dotimes (y (length mapa))
      (dotimes (x (length (first mapa)))
	(if (or (equal (Mapa-Casilla mapa (list x y)) '_)
		(equal (Mapa-Casilla mapa (list x y)) '~))
	    (Modificar-Casilla grafo (list x y) (list (Distancia posActual (list x y)) 
						      (Distancia (list x y) posSalida))))))
    grafo))


(defun RT-Crear-Trayectoria (posActual grafo trayectoria)
; crea una trayectoria
  (let ((coste nil)
	(salida nil))
	
    (setf salida (Copiar-Lista trayectoria))
    (setf coste (Mapa-Casilla grafo posActual))    

    (cond ((equal coste 'M)
	   (setf salida nil))
	  ((equal salida nil)
	   (setf salida (list (+ (first coste) (second coste)) (first coste) (second coste) posActual)))
	  (t (setf (nth 2 salida) (nth 1 coste))
	     (setf (nth 1 salida) (+ (nth 1 salida) (nth 0 coste)))
	     (setf (nth 0 salida) (+ (nth 1 salida) (nth 2 salida)))
	     (setf salida (append salida (list posActual)))))
    salida))


(defun RT-Trayectoria-Comun (trayectoria1 trayectoria2)
; devuelve t si las dos trayectorias comiencen y terminen en el mismo nodo
  (if (and (equal (nth 3 trayectoria1) (nth 3 trayectoria2))
	   (equal (first (last trayectoria1)) (first (last trayectoria2))))
      t
    nil))


(defun RT-Trayectoria-Menor (trayectoria1 trayectoria2)
; devuelve la trayectoria de memor coste
  (if (< (first trayectoria1) (first trayectoria2))
      trayectoria1
    trayectoria2))


(defun RT-Trayectoria-Mayor (trayectoria1 trayectoria2)
; devuelve la trayectoria de memor coste
  (if (>= (first trayectoria1) (first trayectoria2))
      trayectoria1
    trayectoria2))


(defun RT-Insertar-Trayectoria (trayectoria lista)
; inserta una trayectoria en una lista manteniendo el orden
  (let ((salida nil)
	(insertado nil))
    
    (dolist (elto lista)
      (cond ((< (first trayectoria) (first elto))
	     (setf insertado t)
	     (setf salida (cons trayectoria salida))))
      (setf salida (cons elto salida)))
    
    (if (and (equal insertado nil) (not (equal trayectoria nil)))
	(setf salida (cons trayectoria salida)))

  (reverse salida)))


(defun RT-Insertar-CERRADA (trayectoria ruta)
; inserta una trayectoria en la lista CERRADA
  (let ((insertado nil)
	(salida nil))

    (dolist (elto (StructRuta-CERRADA ruta))
      (cond ((RT-Trayectoria-Comun elto trayectoria) 
	     (setf insertado t)
	     (setf salida (append (list (RT-Trayectoria-Menor elto trayectoria)) salida)))
	    (t (setf salida
		     (append (list elto) salida)))))
    
    (if (equal insertado nil)
	(setf salida (RT-Insertar-Trayectoria trayectoria (StructRuta-CERRADA ruta))))

    (setf (StructRuta-CERRADA ruta) salida)))


(defun RT-Insertar-ABIERTA (trayectoria ruta)
; inserta una trayectoria en la lista ABIERTA
  (let ((comun nil)
	(trMayor nil)
	(trMenor nil))

    (cond ((not (equal trayectoria nil))
	   (dolist (elto (StructRuta-ABIERTA ruta))
	     (cond ((RT-Trayectoria-Comun elto trayectoria) 
		    (setf comun 'ABIERTA)
		    (setf trMayor (RT-Trayectoria-Mayor elto trayectoria))		    
		    (setf trMenor (RT-Trayectoria-Menor elto trayectoria)))))	    

	   (dolist (elto (StructRuta-CERRADA ruta))
	     (cond ((RT-Trayectoria-Comun elto trayectoria) 
		    (setf comun 'CERRADA))))	  

	   (cond ((equal comun nil) 
		 ; se inserta en ABIERTA sin más
		  (setf (StructRuta-ABIERTA ruta) 
			(RT-Insertar-Trayectoria trayectoria (StructRuta-ABIERTA ruta))))
		 ; se inserta en ABIERTA y en CERRADA
		 ((equal comun 'ABIERTA)
		  (setf (StructRuta-ABIERTA ruta) 
			(Eliminar-Elemento (StructRuta-ABIERTA ruta) trMayor))
		  (setf (StructRuta-ABIERTA ruta) 
			(RT-Insertar-Trayectoria trMenor (StructRuta-ABIERTA ruta)))
		  (RT-Insertar-CERRADA trMayor ruta))
                 ; se inserta en CERRADA
		 ((equal comun 'CERRADA)
		  (RT-Insertar-CERRADA trayectoria ruta)))))))


(defun RT-Calcular-Ruta (origen destino mapa)
; calcula la ruta óptima entre dos puntos
  (let ((ruta (make-StructRuta))
	(grafo nil)
	(nodoNuevo nil)
	(trayectoria nil))

    (setf grafo (RT-Generar-Grafo origen destino mapa))
    (setf (StructRuta-ABIERTA ruta) (list (RT-Crear-Trayectoria origen grafo nil)))
 
    (loop       
      (setf trayectoria (first (StructRuta-ABIERTA ruta)))
      (setf (StructRuta-ABIERTA ruta) (rest (StructRuta-ABIERTA ruta)))

      (RT-Insertar-CERRADA trayectoria ruta)
      
      ; ramificamos todos los nodos

      (RT-Insertar-ABIERTA 
       (RT-Crear-Trayectoria (Avanzar (first (last trayectoria)) NORTE) grafo trayectoria)
       ruta)

      (RT-Insertar-ABIERTA 
       (RT-Crear-Trayectoria (Avanzar (first (last trayectoria)) SUR) grafo trayectoria)
       ruta)

      (RT-Insertar-ABIERTA 
       (RT-Crear-Trayectoria (Avanzar (first (last trayectoria)) ESTE) grafo trayectoria)
       ruta)

      (RT-Insertar-ABIERTA 
       (RT-Crear-Trayectoria (Avanzar (first (last trayectoria)) OESTE) grafo trayectoria)
       ruta)

      (when (or (equal (StructRuta-ABIERTA ruta) nil)
		(equal (first (last trayectoria)) destino))
	(return trayectoria)))))


(defun RT-Ruta (origen direccion destino mapa)
; devuelve la lista de tareas óptima para ir de origen a destino
  (let ((dir direccion)
	(listaPos nil)
	(tareas nil)
	(listaTareas nil))
    
    (setf listaPos (rest (rest (rest (RT-Calcular-Ruta origen destino mapa)))))

    (dotimes (contador (- (length listaPos) 1) listaTareas)
      (setf tareas (Ir-A (nth contador listaPos) dir (nth (+ contador 1) listaPos)))

      (dolist (elto tareas)
	(cond ((equal 'GirarDerecha elto)
	       (setf dir (Girar-Derecha dir)))
	      ((equal 'GirarIzquierda elto)
	       (setf dir (Girar-Izquierda dir)))))

      (setf listaTareas (Añadir-Elemento tareas listaTareas)))))


; ruta.lsp
