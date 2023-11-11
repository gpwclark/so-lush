#!/usr/bin/env sl-sh

(error-stack-on)

(load "test.lisp")

(if (ns-exists? 'ns-test) (ns-enter 'ns-test) (ns-create 'ns-test))

(ns-import 'shell)
(ns-import 'test)

(defmacro ->
"thrush first macro. inserts result of previous expression as second argument to current expression.
First argument is not evaluated.

Section: shell

(assert-equal
	(str \"I go at the beginning.I'll be stuck in the middle.I'll be at the end.\")
	(-> \"I go at the beginning.\"
		(str \"I'll be stuck in the middle.\")
		(str \"I'll be at the end.\")))"
(&rest args)
	`(if (< (length (quote ,args)) 2)
		(err "-> (thush operator) requires at least two arguments")
		(progn
			(defq fst (first (quote ,args)))
			(loop (curr-form forms) (fst (rest (quote ,args)))
				(if (empty-seq? forms)
					curr-form
					(progn
					(defq sexp nil)
					(defq fcn (first forms))
					(if (seq? fcn)
						(setq sexp (append (list (first fcn)) curr-form (rest fcn)))
						(setq sexp (list fcn curr-form)))
					(recur (eval sexp) (rest forms))))))))

(defmacro ->>
"thrush last macro. inserts result of previous expression as last argument to current expression.
First argument is not evaluated.

Section: shell

Example:

(assert-equal
	(str \"I'll be at the beginning.I'll be more in the middle.I go at the end.\")
	(->> \"I go at the end.\"
		(str \"I'll be more in the middle.\")
		(str \"I'll be at the beginning.\")))"
(&rest args)
	`(if (< (length (quote ,args)) 2)
		(err "->> (thush operator) requires at least two arguments")
		(progn
			(defq fst (first (quote ,args)))
			(loop (curr-form forms) (fst (rest (quote ,args)))
				(if (empty-seq? forms)
					curr-form
					(progn
					(defq sexp nil)
					(defq fcn (first forms))
					(if (seq? fcn)
						(setq sexp (append fcn curr-form))
						(setq sexp (list fcn curr-form)))
					(recur (eval sexp) (rest forms))))))))

(ns-pop)
