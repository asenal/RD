;;--------------------- chap2
(defun myand (x y)
  (cond (x (cond (y 't)
		 ('t '())))
	('t '())))
;if..do..else/nil..
(if (listp 100)
    (format t "100 is a list") 
    (format t "100 is not a list"))
; defparameter/constant
(defparameter *glob* 99)
(defconstant cc (+ *glob* 1))
;boundp
(if (boundp '*glob*)
    (format t "*glob* is bounded")
    (format t "*glob* not bounded"))
;setf
(defparameter *L* (list 1 2 3 4 5))
(setf (car *L*) 'hi)
(setf (cdr *L*) (list 0 0 0 0))
(setf a 'a
      b 's
      c 'l)
(list a b c)

;; do
(defun mysqures (start end)
  (do ((i start (+ i 2))
       ((> i end) 'done))
       (format t "~A ~A~%" i (* i i)))))

;; let: (varialble expression)
(let ((x 1) (y 2))
  (+ x y))

(defun ask-number ()
  (format t "please enter a number:")
  (let ((val (read)))
    (if (numberp val)
	val
	(ask-number))))
;eql
(if (eql 'a 'a)
    (format t "'a equals 'a"))
;remove
(setf lst '(a b c d))
(remove 'a lst)
lst ; lst won't change,this is FP

(list :a 1 :b 2 :c 'z)
(getf (list :a 1 :b 2 :c 3) :c)














;defmacro
(defmacro backwards (expr) (reverse expr))
; (backwards ("hello world!" t format))
(defun make-cd (title artist rating ripped)
       (list :title title :artist artist :rating rating :ripped ripped))
; function or sharp quote to test a function
(function make-cd)
#'make-cd
(defvar *DB* nil)
(defun add-record (cd) (push cd *DB*))
(defun dump-DB ()
  (dolist (cd *DB*)
     (format t "~{~a:~10t~a~%~}~%" cd)))

(add-record (make-cd "Roses" "Kathy Mattea" 7 t))  
(add-record (make-cd "Fly" "Dixie Chicks" 8 t))
(add-record (make-cd "Home" "Dixie Chicks" 9 t))
(dump-DB)
