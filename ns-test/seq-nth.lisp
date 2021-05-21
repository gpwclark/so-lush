#!/usr/bin/env sl-sh

(error-stack-on)

;; almost this whole file is dumb


(ns-push 'nst)
(ns-import 'shell)

(defn yoohoo (x)
      (println "foo-" x))

(defn reduce-times
"
Apply wrapping-fcn to value number of times. Function is recursive. Recursive
binding for value is previous application of wrapping function to value.

Section: sequence
"
	(value wrapping-fcn times)
	(if (<= times 0)
		value
		(recur (wrapping-fcn value) wrapping-fcn (- times 1))))

(defmacro wrap-times
"... my understanding is that reduce-times is strictly better not sure
there's a relevant use cast atm for something that doesn't evalue the bindings
because... that's kind of the point. Delaying application in a macro may just...
create a large string rather than performing a normal iteration.
Wrap to-wrap in the given wrapper the number of iterations.

Section: core

Example:

(assert-equal (list (list 3)) (wrap-times 3 'list 2))
(assert-equal 5 (wrap-times '(wrap-times 5 'list 5) 'first 5))
"
	(to-wrap wrapper iterations) (progn
		(def wrapping-fcn (fn (x item times)
			(if (< times 1)
				(err "Must wrap item at least once.")
				(if (= times 1)
					(list item x)
					(loop (lst iter) ((list item x) 1)
						(if (> iter (- times 1))
							lst
							(recur (append (list item) (list lst)) (+ 1 iter))))))))
		`(,wrapping-fcn ,to-wrap ,wrapper ,iterations)))

#|
(println "start apply: " (str (| (date +%s%N) (cut -b1-13))))
;; (| (date +%s%N) (cut -b1-13))
(reduce-times 1 list 100000)
(println "end apply: " (str (| (date +%s%N) (cut -b1-13))))
(println "start wrap " (str (| (date +%s%N) (cut -b1-13))))
(wrap-times 3 'list 100000)
(println "end wrap " (str (| (date +%s%N) (cut -b1-13))))
(println "dotimes: " (reduce-times 3 list 3))
(println "dotimes: " (reduce-times (reduce-times 5 list 5) first 5))
|#

(defn seq-nth
"
... lol steve already wrote nth



Get nth idx of a [seq?](#root::seq?). Supports positive and negative indexing.
Because vectors support indexing and lists do not this is a much faster
operation for a vector.

Section: sequence

Example:

(def mylist (list 0 1 2 3 4))
(def myvec (vec 0 1 2 3 4))
(assert-equal 0 (seq-nth -5 mylist))
(assert-equal 1 (seq-nth 1 mylist))
(assert-equal 2 (seq-nth 2 mylist))
(assert-equal 3 (seq-nth -2 mylist))
(assert-equal 4 (seq-nth 4 mylist))

(assert-equal 0 (seq-nth -5 myvec))
(assert-equal 1 (seq-nth 1 myvec))
(assert-equal 2 (seq-nth 2 myvec))
(assert-equal 3 (seq-nth -2 myvec))
(assert-equal 4 (seq-nth 4 myvec))"
(idx lst) (progn
	(when (< idx 0)
		(if (> (* -1 idx) (length lst))
		(err "Absolute value of negative idx can't be greater than length of list.")
		(set! idx (+ idx (length lst)))))
	(if (vec? lst)
		(vec-nth lst idx)
		(if (list? lst)
			(if (< idx (length lst))
				(if (= idx 0)
					(first lst)
					(first (reduce-times mylist rest idx))
					)
				(err "idx, must not equal or exceed length of lst, oob."))
			(err "lst, must be a vector or list.")))))


(def mylist (list 0 1 2 3 4))
(def myvec (vec 0 1 2 3 4))
(println "0:" (= 0 (seq-nth -5 mylist)))
(println "1:" (= 1 (seq-nth 1 mylist)))
(println "2:" (= 2 (seq-nth 2 mylist)))
(println "3:" (= 3 (seq-nth -2 mylist)))
(println "4:" (= 4 (seq-nth 4 mylist)))

(println (= 0 (seq-nth -5 myvec)))
(println (= 1 (seq-nth 1 myvec)))
(println (= 2 (seq-nth 2 myvec)))
(println (= 3 (seq-nth -2 myvec)))
(println (= 4 (seq-nth 4 myvec)))

(defn n-list (lst n)
	(if (= n 0)
		(first lst)
		(first (wrap-times (quote lst) 'rest n))))

(set! mylist (list 1000 2000 3000 5000 400))
;;(def twothoustand (first (wrap-times (quote mylist) 'rest 1)))
;;(println "twhoth " twothoustand)
(def three 3)
;;(println (eval (wrap-times 'mylist 'rest three)))
;;(println (n-list mylist 4))

;;(println (= (list (list 3)) (eval (wrap-times 3 'list 2))))
;;(println (= 5 (eval (wrap-times (eval '(wrap-times 5 'list 5)) 'first 5))))

(ns-pop)
