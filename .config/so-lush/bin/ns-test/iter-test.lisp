#!/usr/bin/env sl-sh

(ns-import 'shell)
(ns-import 'iterator)


(defq default-namespaces (collect-vec (filter (fn (x) (not (= x "user"))) (ns-list))))

(println (str "fst: " (first default-namespaces)))
(println (str "fst: " (first default-namespaces)))
(println (str "fst: " (first default-namespaces)))
(println (str "fst: " (first default-namespaces)))
(println (str "fst: " (first default-namespaces)))
(println (str "fst: " (first default-namespaces)))
(println (str "fst: " (first default-namespaces)))
