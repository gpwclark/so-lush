#!/usr/bin/env sl-sh

(ns-import 'shell)

(defmacro wrap-times (x fcn times) (progn
	(eval `(loop (lst iter) ((,fcn ,x) 0)
		(if (> iter (- ,times 1))
			lst
			(recur (append (list ,fcn) (list lst)) (+ 1 iter)))))))

(defn add1 (x) (+ ,x 1))

;(println "my-macro expand: " (expand-macro (wrap-times 3 list 5)))
;(println "my-macro: " (wrap-times 3 list 5))

(println (str "add1: " (add1 4)))
