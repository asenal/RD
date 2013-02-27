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

;; do: (do ((i start iteration) (i start iteration) ..) ((exit condition ) exit action) (iteration actions...))
(defun mysqures_do (start end)
  (do ((i start (+ i 2)))
      ((> i end) '"iteration is over.")
    (format t "~A ~A~%" i (* i i)))))

(defun mysqures_recursion (i end)
  (if (> i end)
      (format t "iteration is over.")
      (progn
	(format t "squre is ~A ~A~%" i (* i i))
	(mysqures_recursion (+ i 1) end))))

(progn
  (format t "this is first sent~%")
  (format t "this is ~A sent~%" '2))

;; dolist
(defun mylength (lst)
  (let ((len 0))
    (dolist (obj lst)
      (format t "~A~%" obj)
      (setf len (+ len 1)))
    (format t "length of ~A is ~A~%" lst len)))

(defun mylength_recursion (lst)
  (if (null lst)
      0
      (+ (mylength_recursion (cdr lst) 1)))

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
;apply funcall
(apply #'+ 1 2 '(3 4 5)) ;last arg must be a list
(funcall #'+ 1 2 3 4 5)
(funcall #'(lambda (x) (+ x 100)) 99)
;; typep
(typep 00 'integer)

;;---------------------------chp3
; eql & equal
(setf x (cons 'a nil))
x
(equal x (cons 'a nil))
(eql x (cons 'a nil))
; copy-list : deep copy
(setf x '(a b c)
      y (copy-list x))
(equal x y)
(eql x y)

;append
(setf L (append '(1 2) '(3 4) '(5 6)))

; mapcar
(mapcar #'(lambda (x) (* x 10)) '(1 2 3))
(mapcar #'list '(a b c) '(1 2 3 4))

; substitute x to y in a cons-tree
(defun subtree(x y tree)
  (if (atom tree)
      (if (eql x tree)
	  y
	  tree)
      (cons (subtree x y (car tree))
	    (subtree x y (cdr tree)))))


; set :member,member-if,member-if-not
(member 'a '(b (a c) a d))
(member 'a '((b c) (a d)) :key #'car)
(member 5 '((1 2) (5 7)) :key #'car :test #'=)
(member-if #'oddp '(1 2 3 4 5))
(member-if-not #'oddp '(1 2 3 4 5))
(member-if-not #'zerop 
                 '(3 6 9 10 11)
                 :key #'(lambda (x) (mod x 3)))
;; mymemberif
(defun mymemberif (fn lst)
  (and (consp lst) ; this 'and' is cool like 'assert',easy to build a 'clean if'
       (if (funcall fn (car lst))
           lst
           (mymemberif fn (cdr lst)))))

; set :find,find-if,find-if-not
(find #\d "here are some letters that can be looked at" :test #'char>)
(find-if #'oddp '(1 2 3 4 5) :from-end t)
(find-if #'oddp '(1 2 3 4 5) :end 4 :from-end t)
(find-if #'oddp '(0 2 3 4 5 6 7 8 9) :end 8)
(find-if-not #'complexp                                    
             '#(3.5 2 #C(1.0 0.0) #C(0.0 1.0))
             :start 1)
; adjoin:join only if not exist
(adjoin 'a '(a b c))
(adjoin 'a '(b c))
(union '(a b) '(a b c))
(intersection '(a b) '(b c))
(set-difference '(a b c d) '(a b))

;sequence
(length '(a b c))
(subseq '(a b c d e) 2 4)
(reverse '(a b c d))
;--palindrome 
(defun mirror? (lst)
  (let ((len (length lst)))
    (and (evenp len)
	 (let ((mid (/ len 2)))
	   (equal (subseq lst 0 mid)
		  (reverse (subseq lst mid)))))))

(mirror? '(a b c c b a))

; sort ,sort will change the list
(setf L '(2 3 1 9 4 12))
(sort L #'<)

; every,some
(every #'oddp '(1 3 5 7))
(some #'evenp '(1 3 5 7 0))
(every #'> '(2 4 6 8 10) '(1 3 5 7 9) '(0 2 4 6 8)) ; a[i]>b[i]>c[i]
; push ,pop,pushnew:pushnew will only push new atom
(setf X '(2 3 4))
(push 1 X)
(pushnew 1 X)
(pop X)
(format nil "~A~%" X)
; dotted list
(car '(a . b))
; assoc-list
(setf asenal '((name . qiulin) (name . henry) (age . 37) (goal 100)))
(setf asenal '((name  qiulin) (name  henry) (age  37) (goal 100)))
(assoc 'name asenal)


;---------------chp4 complicated data structure
(setf *print-array* t)
(setf arr (make-array '(2 3) :initial-element 0))
(aref arr 0 1) ; aref = array reference
(setf (aref arr 0 0) 'asenal)
; vector ,svref=simple vector referrence
(setf V (vector 1 2 'a 'b 'c))
(svref V 2)

;---- string= ,string-equal, char>=, char>, char\=, #\c
(sort "elbow" #'char<)
(equal "asenal" "Asenal")
(string-equal "asenal" "Asenal")
(aref "asenal" 2)
(subseq "asenal" 2 4)
(char "asenal" 2) ; do the samething,but faster than aref
(concatenate 'string "dont't" "panic")
(position #\e "asenal" :from-end t :start 0 :end 5)
(position '(c d) '((a b) (c d)) :test #'equal)
(position 3 '(1 0 2 7 5) :test #'<) ; return the first position x that 3 < L[x]
(position-if #'oddp '(2 4 6 7 9))
(find #\a "cat") 
(find-if #'characterp "asenal")
(remove-duplicates "banana")
(reduce #'+ '(1 2 3))
(reduce #'intersection '((a b c d) (b c d e) (c d e f)))
;--- structure
(defstruct point x y)
(setf P (make-point :x 0 :y 0))
(point-x P) ; call  P.x
(setf (point-y P) 2)
(setf pp (copy-point P)) ; deep !! refers to a totally different pointer

;--- more structure with :conc-name & :print-function
(defstruct (point (:conc-name p-) ; nick name of the structure
		  (:print-function print-point)) ;how to demonstrate structure
  (x 0) ; default value
  (y 0)) 

(defun print-point (PP stream depth)
  (format stream "Structure is : #<~A,~A>" (p-x PP) (p-y PP)))

(defstruct node
  value (l nil) (r nil)) ; this is a simple node,left/right tree is nil by default

;---hash table: make-hash-table,gethash,remhash,maphash
(setf H (make-hash-table :size 10)) ; inspect it !!
(gethash 'name H)
(setf (gethash 'goal H) 100)
(setf (gethash 'captain H) "henry")
(setf (gethash 'name H) "asenal")
(setf (gethash 'wrong H) "tobe deleted")
(remhash 'wrong H)  ; remove an item by key
; maphash will traverse H and give (key value) to #'function
(maphash #'(lambda(k v)(format t "~A is ~A~%" k v)) H) 

;;--------------chp5  control structure
(block mzone
  (format t "here I'm in m-zone")
  (return-from mzone "I'm leaving now,my last words.")
  (format t "this is never seen"))

(block nil
  (return 99))

(defun foo()
  (return-from foo 99))

(let* ((x 1)
       (y (+ x 1)))
  (+ x y))

(let ((x 1)
       (y (+ x 1)))
  (+ x y))

;--case ... otherwise
(defun month_length (mon)
  (case mon 
    ((jan mar may jul aug oct dec) 31)
    ((apr jun sept nov) 30)
    (feb (if (leap-year) 29 28))
    (otherwise "unkonwn month")))

;--
(do ((x 0 (1+ x))
     (y ))
    ((> x 5) "x too overcedes")
  (format t "just print me ~A~%" x))

;;--------------chp6
(fboundp 'elt)
(documentation 'elt 'fuction)
;;--------------chp7
;---------------chp8 Symbol
(symbol-name 'hello)
(list '|Asenal| '|LaTex| '|henry|)
; plist,get
(setf team 'asenal)
(setf (get team 'captain) 'henry)
(setf (get team 'coach) 'wenge)
(setf (get team 'goal) 100)
(symbol-plist team)
(intern "sasa")
(setf qiulin '|sasa's BF|)
; package,intern,unintern,find-symbol
(defpackage "asenal-test"
  (:use "COMMON-LISP" "MY-UTILITIES")
  (:nicknames "APK")
  (:export "constant_acgt" "protein_trans"))

;---------- intern ,unintern,find-symbol
(in-package "COMMON-LISP-USER")
(find-symbol "CAR" 'COMMON-LISP-USER)
(find-symbol "CAR" 'COMMON-LISP)
(intern "never-before")
(find-symbol "never-before")
(unintern 'never-before 'COMMON-LISP-USER)


;-----------------------chp9 number/math
(= 1 1.0)
(eql 1 1.0)
(<= 2 2)
(/= 2 3 4) ; == (and (/= 2 3) (/= 2 4) (/= 3 4))
;signum
(mapcar #'signum '(1 0 -1 -5 23 -0.7))

(max 1 2 3 4)
(min 1 2 3 4)
(minusp -1)
(plusp 1)
(oddp 3)
(evenp 2)
(- 5 3 2) ;=5-3-2
(1+ 2) ; i++
(1- 2) ; i--
(+)
(*)
(/ 2)
(expt 2 3)
(exp 2) ; e as base
(log 8 2)
(sqrt 4)


;;----------------------chp7 IO
; make-pathname,open,close
(setf filename (make-pathname :name "iotest"))
(setf filehandle (open filename :direction :output :if-exists :supersede))
(format filehandle "hello,sasa!")
(close filehandle)
; with-open-file
(setf filename (make-pathname :name "iotest"))
(with-open-file (filehandle filename :direction :output :if-exists :supersede)
  (format filehandle "hello,sasa"))

;(read-line str nil 'eof)
(defun mycat (filename)
  (with-open-file (filehandle filename :direction :input)
    (do ((line (read-line filehandle nil 'eof) (read-line filehandle nil 'eof))) ; var,start,iter-rule
	((eql line 'eof) (format t "~2%line run out,captain ~~")) ; stop-iter, do before stop iter
      (format t "~A~2%" line)))) ; iter body

;read,read-from-string
(read-from-string "a b c d e") 
;format 
g(format nil "~8,4F" 3.1415926)
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
