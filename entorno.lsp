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

; entorno.lsp


(defstruct StructTesoro

  posicion       ; posción del tesoro (x y) 
  (valor 1000))  ; valor del tesoro

(defstruct StructEntorno

  (numTurnos 0)         ; informa del número de ciclos de ejecución
  mapa                  ; casillas que forman el mapa
  listaTesoros          ; lista de tesoros
  listaWumpus           ; lista de Wumpus
  listaBuscaTesoros     ; lista de BuscaTesoros
  listaGritos           ; lista de gritos, sólo duran un turno
  listaWumpusSig        ; lista de Wumpus sig
  listaBuscaTesorosSig  ; lista de BuscaTesoros en el siguiente turno
  listaGritosSig)       ; lista de gritos, sólo duran un turno, en el siguiente turno


; ------------------------------------------------------------------------------------------------------------------
;  Funciones para gestionar los ficheros de configuración
; ------------------------------------------------------------------------------------------------------------------


(defun Entorno-Leer-Fichero (nombre-fichero)
; lee el fichero con la información del entorno
    (with-open-file (origen nombre-fichero :direction :input) 
      (read origen nil 'eof)))


(defun Entorno-Leer-Tesoro (entorno lista)
; lee la información de un tesoro y lo añade a la lista
  (let ((tesoro (make-StructTesoro)))

  (format t " Leyendo Tesoro... ~%")

    (dolist (elto lista)
      (cond ((equal (first elto) 'Posicion) (setf (StructTesoro-posicion tesoro) (second elto)))
	    ((equal (first elto) 'Valor) (setf (StructTesoro-valor tesoro) (second elto)))))
    (setf (StructEntorno-listaTesoros entorno) (Añadir-Elemento (StructEntorno-listaTesoros entorno) tesoro))))


(defun Entorno-Leer-Wumpus (entorno lista)
; lee la información de un wumpus y lo añade a la lista
  (let ((wumpus (make-StructWumpus)))

    (format t " Leyendo Wumpus... ~%")

    (dolist (elto lista)
      (cond ((equal (first elto) 'Nombre) (setf (StructWumpus-nombre wumpus) (second elto)))
	    ((equal (first elto) 'Posicion) (setf (StructWumpus-posicion wumpus) (second elto)))
	    ((equal (first elto) 'Forma) (setf (StructWumpus-forma wumpus) (second elto)))
	    ((equal (first elto) 'Direccion) (setf (StructWumpus-direccion wumpus) (second elto)))	  
	    ((equal (first elto) 'Movimiento) (setf (StructWumpus-movimiento wumpus) (second elto)))
	    ((equal (first elto) 'radioOido) (setf (StructWumpus-radioOido wumpus) (second elto)))
	    ((equal (first elto) 'radioTerritorio) (setf (StructWumpus-radioTerritorio wumpus) (second elto)))
	    ((equal (first elto) 'Instinto) (setf (StructWumpus-instinto wumpus) (second elto)))))
    (setf (StructWumpus-origen wumpus) (StructWumpus-posicion wumpus))
    (setf (StructEntorno-listaWumpus entorno) (Añadir-Elemento (StructEntorno-listaWumpus entorno) wumpus))))


(defun Entorno-Leer-BuscaTesoros (entorno lista)
; lee la información de un buscatesoros y lo añade a la lista
  (let ((bt (make-StructBuscaTesoros)))

    (format t " Leyendo BuscaTesoros... ~%")
    
    (dolist (elto lista)
      (cond ((equal (first elto) 'Nombre) (setf (StructBuscaTesoros-nombre bt) (second elto)))
	    ((equal (first elto) 'Posicion) (setf (StructBuscaTesoros-posicion bt) (second elto)))
	    ((equal (first elto) 'Forma) (setf (StructBuscaTesoros-forma bt) (second elto)))
	    ((equal (first elto) 'Direccion) (setf (StructBuscaTesoros-direccion bt) (second elto)))
	    ((equal (first elto) 'NumFlechas) (setf (StructBuscaTesoros-numFlechas bt) (second elto)))
	    ((equal (first elto) 'Asesino) (setf (StructBuscaTesoros-asesino bt) (second elto)))
	    ((equal (first elto) 'Valiente) (setf (StructBuscaTesoros-valiente bt) (second elto)))
	    ((equal (first elto) 'Espontaneo) (setf (StructBuscaTesoros-espontaneo bt) (second elto)))
	    ((equal (first elto) 'MetodoEsploracion) (setf (StructBuscaTesoros-metodoExploracion bt) (second elto)))
	    ((equal (first elto) 'MapaExploracion) (setf (StructBuscaTesoros-mapaExploracion bt) (second elto)))
	    ((equal (first elto) 'MetodoSalida) (setf (StructBuscaTesoros-metodoSalida bt) (second elto)))
	    ((equal (first elto) 'MapaSalir) (setf (StructBuscaTesoros-mapaSalir bt) (second elto)))
	    ((equal (first elto) 'TesorosBuscar) (setf (StructBuscaTesoros-tesorosBuscar bt) (second elto)))
	    ((equal (first elto) 'MaxTurnosBusqueda) (setf (StructBuscaTesoros-maxTurnosBusqueda bt) (second elto)))
	    ((equal (first elto) 'AnchoMapa) (setf (StructBuscaTesoros-anchoMapa bt) (second elto)))
	    ((equal (first elto) 'AltoMapa) (setf (StructBuscaTesoros-atoMapa bt) (second elto)))))
    (setf (StructEntorno-listaBuscaTesoros entorno) (Añadir-Elemento (StructEntorno-listaBuscaTesoros entorno) bt))))


(defun Entorno-Leer (nombre-fichero entorno)
; lee los datos de un entorno contenidos en el fichero nombre-fichero
  (dolist (elto (Entorno-Leer-Fichero nombre-fichero))
    (cond ((equal (first elto) 'BuscaTesoros) (Entorno-Leer-BuscaTesoros entorno (rest elto)))
	  ((equal (first elto) 'Tesoro) (Entorno-Leer-Tesoro entorno (rest elto)))
	  ((equal (first elto) 'Wumpus) (Entorno-Leer-Wumpus entorno (rest elto)))
	  ((equal (first elto) 'Mapa) (setf (StructEntorno-mapa entorno) (rest elto)))))
  
  ;inicializamos los valores del mapa para el BuscaTesoros
  (dolist (bt (StructEntorno-listaBuscaTesoros entorno))
    (BT-Rellenar-Mapa-Inicial bt))
  
  ; inicializamos los movimientos siguientes 
  (setf (StructEntorno-listaWumpusSig entorno) (StructEntorno-listaWumpus entorno))
  (setf (StructEntorno-listaBuscaTesorosSig entorno) (StructEntorno-listaBuscaTesoros entorno))
  (setf (StructEntorno-listaGritosSig entorno) (StructEntorno-listaGritos entorno)))


; ------------------------------------------------------------------------------------------------------------------
;  Funciones para gestionar las acciones y el estado de los agentes
; ------------------------------------------------------------------------------------------------------------------


(defun Entorno-Buscatesoros-Muerto (entorno)
; comprueba si algún buscatesoros ha muerto
  (let ((posBt nil)
	(posW nil))
    
    (dolist (bt (StructEntorno-listaBuscaTesoros entorno) t) ; bt = BuscaTesoros actual
      (setf posBt (StructBuscaTesoros-posicion bt))      
      (dolist (wumpus (StructEntorno-listaWumpus entorno) t)
	(setf posW (StructWumpus-posicion wumpus)) ; comprobamos si algún wumpus está un su misma pos
	(if (and (equal posBt posW) 
		 (equal (StructWumpus-estado wumpus) 'Vivo))
	    (setf (StructBuscaTesoros-estado bt) 'Muerto)))))) ; el wumpus se come al BuscaTesoros


(defun Entorno-Estado-BuscaTesoros (entorno)
; actualiza el estado de los BuscaTesoros
  (let ((posBt nil))

    (dolist (bt (StructEntorno-listaBuscaTesoros entorno) t)
      (setf posBt (StructBuscaTesoros-posicion bt))
      (if (equal (StructBuscaTesoros-estado bt) 'Vivo)
	  (cond ((equal (Entorno-Casilla entorno posBt) 'P) ; se cae por eun precipicio
		 (setf (StructBuscaTesoros-estado bt) 'Muerto))
		((equal (Entorno-Casilla entorno posBt) 'M) ; movimiento ilegal
		 (setf (StructBuscaTesoros-estado bt) 'Tramposo))))))
  (Entorno-BuscaTesoros-Muerto entorno))


(defun Entorno-Disparar-Flecha (entorno buscatesoros)
; función que le permite a un agente lanzar una flecha
  (let ((dirFlecha (StructBuscaTesoros-direccion buscatesoros))
	(posFlecha (StructBuscaTesoros-posicion buscatesoros))
	(final t))

    (setf (StructBuscaTesoros-numFlechas buscatesoros) 
	  (- (StructBuscaTesoros-numFlechas buscatesoros) 1))

    (loop 
      while (equal final t)
      do (dolist (wumpus (StructEntorno-listaWumpus entorno))
	   (cond ((and (equal (StructWumpus-estado wumpus) 'Vivo) ; si el Wumpus esta vivo
		       (equal posFlecha (StructWumpus-posicion wumpus))) ; y esta el la pos de la flecha
		  (setf final nil)
		  (setf (StructWumpus-estado wumpus) 'Muerto) ; lo matamos
		  (setf (StructEntorno-listaGritosSig entorno)		 
			(Añadir-Elemento (StructEntorno-listaGritosSig entorno)
					 (StructBuscaTesoros-nombre buscatesoros))))))
      (if (equal (Mapa-Casilla (StructEntorno-mapa entorno) posFlecha) 'M) ; se choca con un muro
	  (setf final nil))
      (setf posFlecha (Avanzar posFlecha dirFlecha)))) ; incrementamos la pos de la flecha
t)


(defun Entorno-Mover-Wumpus (entorno)
; función que realiza el movimiento de todos los wumpus que están vivos
  (dolist (wumpus (StructEntorno-listaWumpusSig entorno) t)
    (if (equal (StructWumpus-estado wumpus) 'Vivo)
	(Wumpus-Movimiento wumpus entorno))))


(defun Entorno-Mover-BuscaTesoros (entorno)
; función que realiza el movimiento de todos los BuscaTesoros que están vivos
  (dolist (bt (StructEntorno-listaBuscaTesorosSig entorno) t)
    (if (equal (StructBuscaTesoros-estado bt) 'Vivo)
	(BT-Movimiento bt entorno))))


(defun Entorno-Movimientos (entorno)
; movimientos de los wumpus y de los BuscaTesoros
  (Entorno-Mover-Wumpus entorno)
  (Entorno-Mover-BuscaTesoros entorno))


(defun Entorno-Actualizar (entorno)
; actualiza el estado del entorno
  (setf (StructEntorno-listaWumpus entorno) (StructEntorno-listaWumpusSig entorno))
  (setf (StructEntorno-listaBuscaTesoros entorno) (StructEntorno-listaBuscaTesorosSig entorno))
  (setf (StructEntorno-listaGritos entorno) (StructEntorno-listaGritosSig entorno))

  ; actualizamos el número de turnos
  (setf (StructEntorno-numTurnos entorno) (+ (StructEntorno-numTurnos entorno) 1))
  
  (dolist (bt (StructEntorno-listaBuscaTesorosSig entorno))
    (if (equal (StructBuscaTesoros-estado bt) 'Vivo)
	(setf (StructBuscaTesoros-turnos bt) (+ (StructBuscaTesoros-turnos bt) 1))))

  ; actualizamos el estado de los BuscaTesoros
  (Entorno-Estado-BuscaTesoros entorno)

  ; borramos los gritos
  (setf (StructEntorno-listaGritosSig entorno) nil)
)


; ------------------------------------------------------------------------------------------------------------------
;  Funciones para mostrar la información en pantalla y dibujar los mapas
; ------------------------------------------------------------------------------------------------------------------


(defun Entorno-Casilla (entorno posicion)
; devuelve mapa la casilla indicada por posicion
  (Mapa-Casilla (StructEntorno-mapa entorno) posicion))

(defun Entorno-Dibujar-Wumpus (entorno posicion)
; dibuja a un Wumpus
  (let ((resultado nil))

    (dolist (wumpus (StructEntorno-listaWumpus entorno) resultado)
      (cond ((equal posicion (StructWumpus-posicion wumpus))
	     (cond ((equal resultado nil)
		    (cond ((equal (StructWumpus-estado wumpus) 'Vivo)			  
			   (format t " ~S" (StructWumpus-forma wumpus))) ; si está vivo pintamos su "forma"
			  ((equal (StructWumpus-estado wumpus) 'Muerto)
			   (format t " +"))) ; pinamos un + si está muerto		    
		    (setf resultado t))))))))


(defun Entorno-Tesoro-Visible (entorno posicion)
; función que devuelve t si el tesoro está visible en "posicion
  (let ((resultado nil))

    (dolist (tesoro (StructEntorno-listaTesoros entorno) resultado)
      (cond ((equal posicion (StructTesoro-posicion tesoro)) (setf resultado t))))))


(defun Entorno-Dibujar-BuscaTesoros (entorno posicion)
; función que dibuja un BuscaTesoros 
 (let ((resultado nil))

    (dolist (bt (StructEntorno-listaBuscaTesoros entorno) resultado)
      (cond ((equal posicion (StructBuscaTesoros-posicion bt))
	     (cond ((equal resultado nil)
		    (cond ((equal (StructBuscaTesoros-estado bt) 'Vivo)			  
			   (format t " ~S" (StructBuscaTesoros-forma bt))) ; si esta vivo pinta su "forma"
			  ((equal (StructBuscaTesoros-estado bt) 'Muerto)
			   (format t " #")) ; pintamos un # si esta muerto
			  ((equal (StructBuscaTesoros-estado bt) 'Fuera)
			   (format t " |"))) ; pintamos un | si esta fuera de la cueva
		    (setf resultado t))))))))


(defun Entorno-Dibujar-Mapa (entorno)
; función encargada de dibujar el mapa
  (let ((posMapa nil))

    (format t "~% Mapa: ~%")
 
    (dotimes (y (length (StructEntorno-mapa entorno)))
      (format t " ~%  ->")
      (dotimes (x (length (nth y (StructEntorno-mapa entorno))))
	(setf posMapa (list x (- (length (StructEntorno-mapa entorno)) y 1)))
     
	(cond ((Entorno-Dibujar-BuscaTesoros entorno posMapa) t) ; dibujamos un BuscaTesoros
	      ((Entorno-Dibujar-Wumpus entorno posMapa) t) ; dibujamos un Wumpus
	      ((Entorno-Tesoro-Visible entorno posMapa) (format t " T")) ; dibujamos el Tesoro
	      (t (format t " ~S" (nth x (nth y (StructEntorno-mapa entorno)))))))))

  (format t " ~%~%")
  t)


(defun Entorno-Informacion-Wumpus (entorno)
; escribe en pantalla la información del Wumpus
  (let ((contador 1))

    (dolist (w (StructEntorno-listaWumpus entorno))
      (format t "~% Datos del Wumpus: ~S/~S~%" contador (length (StructEntorno-listaWumpus entorno)))
      (format t "  -> Nombre:         ~S~%" (StructWumpus-nombre w))
      (format t "  -> Forma:          ~S~%" (StructWumpus-forma w))
      (format t "  -> Estado:         ~S~%" (StructWumpus-estado w))
      (format t "  -> Dirección:      ~S~%" (StructWumpus-direccion w))
      
      (setf contador (+ contador 1)))))


(defun Entorno-Informacion-Buscatesoros (entorno)
; muestra en pantalla la información del BuscaTesoros
  (let ((contador 1))
    (dolist (bt (StructEntorno-listaBuscaTesoros entorno))
      (format t "~% Datos del BuscaTesoros: ~S/~S~%" contador (length (StructEntorno-listaBuscaTesoros entorno)))
      (format t "  -> Nombre:         ~S~%" (StructBuscatesoros-nombre bt))
      (format t "  -> Forma:          ~S~%" (StructBuscatesoros-forma bt))
      (format t "  -> Estado:         ~S~%" (StructBuscaTesoros-estado bt))
      (format t "  -> Dirección:      ~S~%" (StructBuscaTesoros-direccion bt))
      (format t "  -> NumFlechas:     ~S~%" (StructBuscaTesoros-numFlechas bt))
      (format t "  -> Turnos:         ~S~%" (StructBuscaTesoros-turnos bt))
      (format t "  -> Objetivo:       ~S~%" (StructBuscaTesoros-objetivo bt))
      (format t "  -> WumpusMuertos:  ~S~%" (StructBuscaTesoros-wumpusMuertos bt))
      (format t "  -> Tesoros:        ~S~%" (length (StructBuscaTesoros-listaTesoros bt)))
      (format t "  -> Salidas:        ~S~%" (StructBuscaTesoros-listaSalidas bt))
      (format t "  -> Sensores:       ~S~%" (StructBuscaTesoros-estadoSensores bt))
      (format t "  -> Tareas:         ~S~%" (StructBuscaTesoros-listaTareas bt))

      (BT-Dibujar-Mapa bt)
      (format t "~%")
      
      (setf contador (+ contador 1)))))


(defun Entorno-Dibujar (entorno salto info) 
; dibuja el mapa y muesta la información del Wumpus y del BuscaTesoros
  (cond ((= (mod (StructEntorno-numTurnos entorno) salto) 0)

	 (format t "~%-----------------------------------------------------------------------")
	 (format t "~% Turno: ~S~%" (StructEntorno-numTurnos entorno))

	 (if (Esta info 'Mapa) (Entorno-Dibujar-Mapa entorno))
	 (if (Esta info 'InfoWumpus) (Entorno-Informacion-Wumpus entorno))
	 (if (Esta info 'InfoBuscaTesoros) (Entorno-Informacion-Buscatesoros entorno))

	 (read-char))))


; entorno.lsp
