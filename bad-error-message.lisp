#!/usr/bin/env sl-sh

(ns-import 'shell)
(ns-import 'iterator)


(defn string-interp
    "Given a string, interpolate and return a string.

    Section: string"
    (line)
    (str-trim
      (apply
        str
        (collect (interleave (map (fn (x) (if (pair? x) (eval x) x)) (read-all line)) (repeat " "))))))



(loop (filething writething) ((open "version.txt") (open "version.md" :create :truncate))
    (do
      (let ((line (read-line filething)))
      (if (not (nil? line))
        (let* ((ret (get-error (string-interp line))))
            (do
              (if (= :ok (car ret))
                (write-string writething (cdr ret))
                (write-string writething line))
              (recur filething)))
        (close filething)
        (close writething)))))


;; error is on line 19, but the real issue is, recur needs two arguments!
