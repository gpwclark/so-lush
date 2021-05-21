#!./target/debug/sl-sh

(ns-import 'shell)
(ns-import 'math)

(def bindings
	(getopts
		(make-hash
			(list
			(join :--mean
					(make-hash '((:arity . 2)
							(:type . :int?))))
			(join :--n
					(make-hash '((:arity . 2)
							(:type . :int?))))
			(join :--std-dev
					(make-hash '((:arity . 2)
							(:type . :int?))))))
		args))

(println "bindings: " bindings)



(def t-test (/ (- (vec-nth (hash-get bindings :--mean) 0)
                  (vec-nth (hash-get bindings :--mean) 1))
   (sqrt (+ (/ (vec-nth (hash-get bindings :--std-dev) 0)
               (vec-nth (hash-get bindings :--n) 0))
            (/ (vec-nth (hash-get bindings :--std-dev) 1)
               (vec-nth (hash-get bindings :--std-dev) 1))))))

(println "test: " t-test)
