(ns-new 'add1)
(ns-import 'shell)

(defn add1 (x)
	(+ x 1))

(ns-export-all 'add1)
