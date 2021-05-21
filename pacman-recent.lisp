#!/usr/bin/env sl-sh

;; "load" calls go above here but below interpreter directive.
(if (ns-exists? 'arch) (ns-enter 'arch) (ns-create 'arch))
(ns-import 'shell) ;; imports from load calls & body below

;;(defq packages (str-trim :whitespace (str (pacman -Qq))))

;; call to str too slow
;;(defq packages-installed-list (str (| (cat /var/log/pacman.log) (grep -i "\[ALPM\] installed"))))
;;(println "paclist: " (packages-installed-list))

;; goal here was to sort list of packages by installed date
#|
(defn bracketed-by (string delim0 delim1)
	(vec-nth 0 (str-split delim1 (vec-nth 1 (str-split delim0 string)))))

(defq pac-log (open "/var/log/pacman.log" :read))
(defq pac-map
	(loop (pac-log pac-map) (pac-log (make-hash)) (progn
		(defq line (read-line pac-log))
		(if (nil? line)
			pac-map
			(when (str-contains "[ALPM] installed" line)
				(progn
				(defq cols (str-split :whitespace line))
				(println "cols: " cols)
				(defq date-str (bracketed-by (vec-nth 0 cols) "[" "]"))
				(defq package-name (vec-nth 3 cols))
				(defq version (bracketed-by (vec-nth 4 cols) "(" ")"))
				(if (hash-haskey pac-map col3)
					(progn
						(defq err-str (str
							"Existing: " (hash-get pac-map package-name)
							"New: version: " version
							", date string: "  date-str))
						(err err-str))
					(progn
					(defq entry (make-has))
					(hash-set! entry :version version)
					(hash-set! entry :date date-str)
					(hash-set! pac-map package-name entry)
					(println "name: " package-name ", version: " version ", date: " date-str)
					(recur pac-log pac-map)))
				)))
		(recur pac-log pac-map))))

;;(for package packges (progn))
|#

(alias makepkg
"[makepkg](https://wiki.archlinux.org/index.php/Makepkg) is used to build PKGBUILD
files. When using makepkg, I prefer \"makepkg -ic\" i installs and c cleans up
build artifacts left over.
Section: os"
	(makepkg))


(ns-auto-export 'arch')
(ns-pop) ;; must be after body
