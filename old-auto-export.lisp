#!./target/debug/sl-sh

;; mk-post.lisp ... which is a little convultues and needs to be at least
;; explicityly more verbose about being a general sl-sh md file evalable thing
;; not just someething built for jekyll. this might require ability to append
;; to existing file to preserver jekyll frontmatter. anyway, we should re-implement
;; ns-auto-export because i can't find it because it's useful. maybe we rename it
;; to like, ns-export-no-dash or something, but if it's documented i like the
;; convention of using the dash.
(ns-push 'nae)
(ns-import 'shell)
(ns-import 'iterator)

(def foo "lkj")
(def moo "lkj")
(def -priv "lkj")

(ns-export '(cd))
(println (time (ns-auto-export 'nae)))
(ns-pop)

;;(println "syms: " *std-lib-syms-hash*)
(println "syms: " (eval (sym (str 'nae "::*ns-exports*"))))

