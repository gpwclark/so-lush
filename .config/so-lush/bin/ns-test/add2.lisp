(ns-new 'add2)
(ns-import 'shell)

(error-stack-on)

(defn make-adder (to-add iterations)
	(loop (add iter) (to-add 0) (if (> iter (- iterations 1)) add (recur (+ 1 add) (+ 1 iter)))))

(defn add2 (x)
	(make-adder x 2))

(ns-export-all 'add2)
(ns-pop)
