;;---- this is a example of breadth-first-search to find a shortest path between 'a and 'd in a net. 
;;---- a node is defined as a list:(x y z) ,x is current node,y,z is its adjacent neighbor

(defun shortest-path (start end net)
  (bfs end (list (list start)) net))

(defun bfs (end queue net)
  (if (null queue)
      nil
      (let ((path (car queue)))
	(format t "path is: ~A ~%queue is: ~A~%" path queue)
        (let ((node (car path))) ; notice a path is created by 'cons new_node old-path',so use car to get the newly added node
          (if (eql node end)
              (reverse path)
              (bfs end
                   (append (cdr queue)                 ;shift out current path,leave only the cdr part
                           (new-paths path node net))  ;extend the adjacent node to current path,append to the end of our queue
                   net))))))

(defun new-paths (old-path current_node net)
  (mapcar #'(lambda (new_node)                  ;current node's descendant is accepted as 'new_node'
              (cons new_node old-path))         ;the newly added node is head now,this way a path is always inversed
          (cdr (assoc current_node net))))      ;(cdr assoc current_node net) return all descendant nodes

;---------- test 
(setf net '((a b c) (b c) (c d)))
(shortest-path 'a 'd net)
