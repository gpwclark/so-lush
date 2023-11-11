#!/usr/bin/env sl-sh

(ns-import 'shell)

(loop (file) ((open "version.txt")) (do
    (println (str-push! "" (read-line file)))
    ))

