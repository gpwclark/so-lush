#!/usr/bin/env sl-sh

(error-stack-on)

(load "add2.lisp")
(ns-import 'shell)
(ns-import 'add2)
(ns-push 'nst)

(defn -foo (x) (str "foo-" x))

(defn yoohoo (x) (str "foo-" x))

(defmacro -whowho (x) (str "foo-" x))

(defmacro -whowho (x) (str "foo-" x))

(defq input 8)

(defq -inputz 8)

(defn -wrap-times (x item times)
	(if (< times 1)
		(err "Must wrap item at least once.")
		(if (= times 1)
			(list item x)
			(loop (lst iter) ((list item x) 1)
				(if (> iter (- times 1))
					lst
					(recur (append (list item) (list lst)) (+ 1 iter)))))))

(defmacro wrap-times (x item times)
	(eval `(-wrap-times ,x ,item ,times)))

(println "Given input: " input)
(println "func? input: " (func? input))
(println "func? yoohoo " (func? yoohoo))

(println "add2: " (add2 input))
(println "exports in ns-test: " ns-test::*ns-exports*)

;(println "my-macro expand: " (expand-macro (wrap-times 3 list 5)))
;(println "my-macro: " (wrap-times 3 list 5))

;;(println "macro-wrap-times: " (eval (wrap-times 3 'list 5)))
;;(println "unwrap-macro-wrap-times: " (eval (wrap-times (wrap-times 5 'list 5) 'first 4)))
(println "macro-wrap-times: " (wrap-times 3 'list 5))
(println "unwrap-macro-wrap-times: " (wrap-times '(wrap-times 5 'list 5) 'first 5))

(defq mylist (list 0 1 2 3 4 5 6))
(println "myidx: " (first (wrap-times 'mylist 'rest 6)))

(ns-pop)
