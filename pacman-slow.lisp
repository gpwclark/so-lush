#!/bin/sl-sh

;; "load" calls go above here but below interpreter directive.
(if (ns-exists? 'pacman) (ns-enter 'pacman) (ns-create 'pacman))
(ns-import 'shell) ;; imports from load calls & body below

;;(defq packages (str-trim :whitespace (str (pacman -Qq))))

;; call to str too slow
(defq packages-installed-list (str (| (cat /var/log/pacman.log) (grep -i "\[ALPM\] installed"))))
(println "paclist: " (packages-installed-list))
