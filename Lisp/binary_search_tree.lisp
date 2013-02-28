(defstruct (node (:print-function
		  (lambda (node s d)
		    (format s "#<~A>" (node-value node)))))
  value (l nil) (r nil)) ;default 'l' is 'nil',default 'r' is nil

(defun bst-min (bst)
  (and bst 
       (or (bst-min (node-l bst)) bst)))

(defun bst-max (bst)
  (and bst
       (or (bst-max (node-r bst)) bst)))

(defun bst-find (cmp obj bst)
  (if (null bst)
      nil 
      (let ((value (node-value bst)))
	(if (eql obj value)
	bst
	(if (funcall cmp obj value)
	    (bst-find cmp obj (node-l bst))
	    (bst-find cmp obj (node-r bst)))))))

(defun bst-traverse (fn bst)
  (when bst
    (bst-traverse fn (node-l bst))
    (funcall fn (node-value bst))
    (bst-traverse fn (node-r bst))))
;;----
(defun bst-insert (obj bst cmp)
  " bst-insert accept 3 paras: a node, a tree, a comparasion function. If the tree is nil,insert the node as root."
  (if (null bst)
      (make-node :value obj)
      (let ((value (node-value bst)))
	(if (eql obj value)
	    bst ; return the tree if obj is already exist in the tree.
	    (if (funcall cmp obj value)
		(make-node
		 :value value
		 :l (bst-insert obj (node-l bst) cmp)
		 :r (node-r bst))
		(make-node
		 :value value
		 :r (bst-insert obj (node-r bst) cmp)
		 :l (node-l bst)))))))

;;---------
(defun bst-remove (obj bst cmp)
  (if (null bst)
      nil
      (let ((value (node-value bst)))
	(if (eql obj value)
	    (percolate bst)
	    (if (funcall cmp obj value)
		(make-node
		 :value value
		 :l (bst-remove obj (node-l bst) cmp)
		 :r (node-r bst))
		(make-node
		 :value value
		 :r (bst-remove obj (node-r bst) cmp)
		 :l (node-l bst)))))))

(defun percolate (bst) 
  "choose qianqu/houqu randomly"
  (let ((l (node-l bst)) (r (node-r bst)))
    (cond ((null l) r)
	  ((null r) l)
	  (t (if (zerop (random 2))
		 (make-node :value (node-value (bst-max l))
			    :r r
			    :l (bst-remove-max l))
		 (make-node :value (node-value (bst-min r))
			    :r (bst-remove-min r)
			    :l l))))))

(defun bst-remove-min (bst)
  (if (null (node-l bst))
      (node-r bst)
      (make-node :value (node-value bst)
		 :l (bst-remove-min (node-l bst))
		 :r (node-r bst))))

(defun bst-remove-max (bst)
  (if (null (node-r bst))
      (node-l bst)
      (make-node :value (node-value bst)
		 :l (node-l bst)
		 :r (bst-remove-max (node-r bst)))))

;--- test build & insert
(fboundp 'bst-insert)
(documentation 'bst-insert 'function)

(setf nums nil)
(dolist (x '(5 8 4 2 1 9 6 7 3))
  (setf nums (bst-insert x nums #'<)))
(bst-find #'= 12 nums)
(bst-traverse #'princ nums)
