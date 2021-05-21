#!./target/debug/sl-sh

(ns-import 'shell)
(ns-import 'iterator)

(defn avg (lst N)
       (chain lst
              (reduce + 0 _)
              (/ _ (int->float N))))

(defn std-dev (lst)
      (let* ((variance (fn (coll x-bar) (map (fn (x) (pow (- x x-bar) 2)) coll)))
             (coll (collect lst))
             (N (length coll))
             (average (avg coll N))
             (vrnce (variance coll average))
             (vrnce-sum (reduce + 0 vrnce)))
       (sqrt (/ vrnce-sum N))))

(println "std dev: " (time (std-dev (range 1 (str->int (vec-nth args 0))))))



