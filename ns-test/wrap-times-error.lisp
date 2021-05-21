#!/usr/bin/env sl-sh

(ns-import 'shell)

(defn -wrap-times (x item times) (do
	(loop (lst iter) ((list item x) 0)
		(if (> iter (- times 1))
			lst
			(recur (append (list item) (list lst)) (+ 1 iter))))))

(defmacro wrap-times (x item times) (do
	(eval `(-wrap-times ,x ,item ,times))))

(println "macro-wrap-times: " (wrap-times '3 'list 5))
