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


; util.lsp


(defconstant NORTE '(0 1))
(defconstant SUR '(0 -1))
(defconstant ESTE '(1 0))
(defconstant OESTE '(-1 0))

(defconstant MAXRANDOM 10000)

(defconstant RETROCEDER '(GirarDerecha GirarDerecha Avanzar))
(defconstant ESQUIVAR-DER '(GirarDerecha Avanzar))
(defconstant ESQUIVAR-IZQ '(GirarIzquierda Avanzar))

 
; ------------------------------------------------------------------------------------------------------------------
;  Funciones para gestionar el manejo de listas
; ------------------------------------------------------------------------------------------------------------------


(defun Copiar-Lista (lista)
; copia una lista
  (let ((salida nil))
    (dolist (elto lista salida)
      (setf salida (cons elto salida)))
  (reverse salida)))


(defun Añadir-Elemento (lista elto)
; añade "elto" a la "lista"
  (cond ((listp elto) (append elto lista))
	(t (cons elto lista))))


(defun Extraer-Elemento (lista pos)
; elimina el elemento situado en pos de "lista"
 (let (resultado '())
   (dotimes (contador (length lista) resultado)
     (cond ((not (= contador pos)) 
	    (setf resultado (append resultado (list (nth contador lista)))))))))


(defun Eliminar-Elemento (lista dato)
; elimina dato de lista
  (let (resultado '())
    (dolist (elto lista resultado)
      (if (not (equal elto dato))
	  (setf resultado (cons elto resultado))))
    (reverse resultado)))


(defun Esta (lista elto)
; devuelve t si elto esta en "lista"
  (let ((resultado nil))
    (dolist (dato lista resultado)
      (if (equal dato elto) (setf resultado t)))))


; ------------------------------------------------------------------------------------------------------------------
;  Funciones para gestionar los movimientos de los agentes
; ------------------------------------------------------------------------------------------------------------------


(defun Avanzar (posicion direccion)
; devuelve posicion 
  (list (+ (first posicion) (first direccion))
	(+ (second posicion) (second direccion))))


(defun Girar-Derecha (direccion)
; devuelve el resultado de girar direccion a la derecha
  (cond ((equal direccion norte) ESTE)
	((equal direccion este) SUR)
	((equal direccion sur) OESTE)
	((equal direccion oeste) NORTE)))


(defun Girar-Izquierda (direccion)
; devuelve el resultado de girar direccion a la izquierda
  (cond ((equal direccion norte) OESTE)
	((equal direccion este) NORTE)
	((equal direccion sur) ESTE)
	((equal direccion oeste) SUR)))


(defun NumAleatorio ()
; genera un número aleatorio entre 0.0 y 1.0
  (float (/ (random MAXRANDOM) maxRandom)))


(defun Esquivar ()
; devuel la lista de tareas para esquivar un muro
  (if (equal (random 2) 1) ESQUIVAR-DER
    ESQUIVAR-IZQ))


(defun Distancia (origen destino)
; calcula la distancia entro dos ptos
  (sqrt (+ (expt (- (first destino) (first origen)) 2)
	   (expt (- (second destino) (second origen)) 2))))


(defun Distancia-Entero (origen destino)
; calcula la distancia entro dos ptos usando arimética entera
  (isqrt (+ (expt (- (first destino) (first origen)) 2)
	    (expt (- (second destino) (second origen)) 2))))


(defun Mapa-Casilla (mapa posicion)
; devuelve la casilla de "mapa" que esta en "posición"
; si no salimos de las dim devolvemo M = un muro
  (if (and (>= (first posicion) 0) 
	   (>= (second posicion) 0)
	   (< (second posicion) (length mapa)) 
	   (< (first posicion) (length (first mapa))))
      (nth (first posicion) (nth (- (length mapa) (second posicion) 1) mapa))
    'M))


(defun Modificar-Casilla (mapa posicion valor)
; modifica una posicion de "mapa" con "valor"
  (if (and (>= (first posicion) 0)
	   (>= (second posicion) 0)
	   (< (second posicion) (length mapa)) 
	   (< (first posicion) (length (first mapa))))
      (setf (nth (first posicion) (nth (- (length mapa) (second posicion) 1) mapa)) valor)
    nil))


; util.lsp
