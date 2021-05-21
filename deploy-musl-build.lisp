#!../../slsh/target/debug/sl-sh
;; #!/usr/bin/env sl-sh

(ns-import 'shell)

(def getopts-bindings
		(make-hash
			(list
			(join :--sl-sh-dir
					(make-hash '((:arity . 1)
							(:type . :fs-dir?)
							(:required . #t)
							(:doc . "local sl-sh git directory."))))
			(join :--dest-dir
					(make-hash '((:arity . 1)
							(:type . :fs-dir?)
							(:required . #t)
							(:doc . "destination directory for standalong stripped sl-sh binary.")))))))

(def bindings
	(getopts
		getopts-bindings
		args))

(println "bindings: " bindings)

(println "sl-sh-dir: " (hash-get bindings :--sl-sh-dir))
(println "dest-dir: " (hash-get bindings :--dest-dir))

(defn deploy-musl-build
	"Use to deploy a standalone version of sl-sh to a directory.
$((getopts-help getopts-bindings))"
	  ()
	(let* ((sl-sh-dir (hash-get bindings :--sl-sh-dir))
		(dest-dir (hash-get bindings :--dest-dir))
		(musl-target "./target/x86_64-unknown-linux-musl/release/sl-sh")
		(ret (get-error
			   (pushd sl-sh-dir)
				$(cargo build --target x86_64-unknown-linux-musl --release)
				$(strip $musl-target)
				$(cp $musl-target $dest-dir))))
	  (do
		(popd)
		(if (= :ok (car ret))
		  (println "Success!")
		  (println "Error!" (cdr ret))))))

(println (doc 'deploy-musl-build))
(deploy-musl-build)

