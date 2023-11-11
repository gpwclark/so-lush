#!/bin/sl-sh

;; all "load" calls must be above this line and below the sl-sh shebang interpreter directive.
(if (ns-exists? 'meow) (ns-enter 'meow) (ns-create 'meow))

(ns-import 'shell)

(echo "ok")

(println (first (read-all (str "'(1 2 3)"))))
(println (println (list? (first (rest (read-all (str "'(1 2 3)")))))))
(println (first (read-all (str "`aaaa"))))
(println (first (rest (read-all (str "`aaaa")))))

(defn temp-dir () "/tmp")

(ns-pop) ;; must be last line
