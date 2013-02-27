(defun n-elts (elt n)
  (if (> n 1)
      (list n elt)
      elt))

(defun list-of (n elt)
  (if (zerop n)
      nil
      (cons elt (list-of (- n 1) elt))))

(defun compr (elt n lst)
  (if (null lst)
      (list (n-elts elt n))
      (let ((next (car lst)))
	(if eql next elt)
	(compr elt (+ n 1) (cdr lst))
	(cons (n-elts elt n)
	      (compr next 1 (cdr lst))))))

(defun compress (x)
  (if (consp x)
      (compr (car x) 1 (cdr x))
      x))

(defun uncompress (lst)
  (if (null lst)
      nil 
      (let ((elt (car lst))
	    (rest (uncompress (cdr lst))))
	(if (consp elt)
	    (append (apply #'list-of elt)
		   rest)
	    (cons elt rest)))))


;; test
(list-of 5 'abc)
(uncompress '(0 1 2 (3 4) 5))
(compress '(0 0 0 1 2 2 3 3 3))

