#!/bin/sl-sh

(ns-import 'shell)

(defq tst (open "sample-file.txt" :create))
(chmod +x tst)
