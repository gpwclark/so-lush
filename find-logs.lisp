#!/usr/bin/env sl-sh

(ns-push 'logfinder)
(ns-import 'shell)

(for file in (map str-trim (str-split :whitespace (str (find $PWD -iname "*.log"))))
     (do (println "File: " file)))

(ns-auto-export 'logfinder)
(ns-pop)
