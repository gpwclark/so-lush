(ns-push 'shell-docs)

(ns-import 'shell)

(def start-time (str (str-trim $(date +%s%N | cut -b1-13))))
(def thecount 0)
(defn print-load-time (string)
(println (str thecount " Load time[" string "]: "
    (- (str->int (str (str-trim $(date +%s%N | cut -b1-13))))
    (str->int start-time)) "ms"))
(set! thecount (+ 1 thecount)))

(set! print-load-time (fn (x)))

;; long lost documentation for system commands {{{

(print-load-time "	before long lost documentation for system commands ")

(alias wget
	"
	to get a whole site...
	wget --mirror --convert-links --adjust-extension --page-requisites --no-parent https://doc.rust-lang.org/book/
	* --mirror – Makes (among other things) the download recursive.
	* --convert-links – convert all the links (also to stuff like CSS stylesheets) to relative, so it will be suitable for offline viewing.
	* --adjust-extension – Adds suitable extensions to filenames (html or css) depending on their content-type.
	* --page-requisites – Download things like CSS style-sheets and images required to properly display the page offline.
	* --no-parent – When recursing do not ascend to the parent directory. It useful for restricting the download to only a portion of the site.
	"
	(syscall (str $(which wget))))

(alias docker-compose
"
To run latest docker container:
	docker-compose stop
	docker-compose rm -f
	docker-compose -f docker-compose.yml up -d
	# i.e. remove the containers before running up again.
	# What one needs to keep in mind when doing it like this is that data volume
	# containers are removed as well if you just run rm -f. In order to prevent
	# that I specify explicitly each container to remove:
	docker-compose rm -f application nginx php
Section: sys-docs
"
	(syscall (str $(which docker-compose))))

(alias vcsh
"
repo		| description					| remote
===================================================================================================================
clcli		| common lisp cli programs 			| git@github.com:gpwclark/clcli.git
-------------------------------------------------------------------------------------------------------------------
i3		| i3						| git@github.com:gpwclark/i3.git
-------------------------------------------------------------------------------------------------------------------
leo		| legacy note taking app			| git@bitbucket.org:price_clark/leo.git
-------------------------------------------------------------------------------------------------------------------
mr		| public - my repos manages			| git@github.com:gpwclark/vcsh_mr.git
		| which repos are active			|
-------------------------------------------------------------------------------------------------------------------
share		| anything private / notes/ etc. 		| git@bitbucket.org:price_clark/share-config.git
-------------------------------------------------------------------------------------------------------------------
spacemacs	| emacs / doom config				| git@github.com:gpwclark/spacemacs.git
-------------------------------------------------------------------------------------------------------------------
systemd		| user space systemd stuffz			| git@github.com:gpwclark/systemd.git
-------------------------------------------------------------------------------------------------------------------
tmux		| tmux 						| git@github.com:gpwclark/tmux.git
-------------------------------------------------------------------------------------------------------------------
vim		| vim						| git@github.com:gpwclark/vim.git
-------------------------------------------------------------------------------------------------------------------
zsh		| zsh PLUS everything else I want, e.g. inputrc	| git@github.com:gpwclark/zsh.git
		| , environment initalization scripts, etc.	|
===================================================================================================================

! don't forget about `vcsh foreach add -u` and ``vcsh foreach status -uno` # to ignore untracked files

- settuing up a new machine
1. install mr and vcsh
2.
vcsh clone git@github.com:gpwclark/vcsh_mr.git
```
3. Edit any desired configuration in .mrconfig file and the config directory in ~/.config/mr/
```
mr up
```
4. done!


full list:
$(vcsh list)
"
	(syscall (str $(which vcsh))))

(alias yay "see doc 'vim'
Command 		|		Description
-----------------------------------
;;yay <Search Term> 			Present package-installation selection menu.
;;yay -Ps 				Print system statistics.
;;yay -Yc 				Clean unneeded dependencies.
;;yay -G <AUR Package> 			Download PKGBUILD from ABS or AUR.
;;yay -Y --gendb				Generate development package database used for devel update.
;;yay -Syu --devel --timeupdate 		Perform system upgrade, but also check for development package updates and use PKGBUILD modification time (not version number) to determine update.

Section: arch" (syscall (str $(which yay))))

(alias vi "see doc 'vim'
Section: sys-docs" (syscall (str $(which vim))))

(alias vim
"
- how to replace something with a newline in vim.
:set magic
:%s/{/{^M/g
To get the ^M character, type Ctrl + V and hit Enter
Section: sys-docs
"
	(syscall (str $(which vim))))

(alias tmux
"List of things no one can remember:
- change cwd of session
	- C-a + : then input attach-session -t . -c new-cwd
- copy and paste
	- initiate: C-a + [
	- more initiate: hit space bar (enter visual block highlight text mode)
	- hit enter to stick in paste buffer
	- paste normally or with: C-a + ]
Section: tmux"
	(syscall (str $(which tmux))))

(alias journalctl
"GENERAL KNOWLEDGE:
[learning](https://www.redhat.com/sysadmin/mastering-systemd)
systemd stores logs in binary format with lots of fields for every given
system log, to showcase all possible filter options run:
	#> journalctl --output=verbose --all

cool stuff:
	/usr/bin/bash # by binary
	_COMM=\"sshd\" just name of script or binary
	--boot # since boot
	--catalog # instructs journalctl to show context around lines, e.g. computer reboots,
				service stopping restarting
	--utc #!
	-k  # kernel messages
	_UID=1000 -n # by user
	--no-pager # good for read
	-n # recent logs
	-n/--lines=1024 #last 1024 logs
	-f/--follow
	--output [json/json-pretty/others] # formatted in json!
	--priority/-p N # provide log level

log levels:
	journalctl -unit=sshd --priority 3 --output json-pretty
	0: emergency
	1: alerts
	2: critical
	3: errors
	4: warning
	5: notice
	6: info
	7: debug

time:
	# \"yesterday\", \"today\", \"tomorrow\", or \"now\"
	journalctl --since \"2015-01-10\" --until \"2015-01-11 03:00\"
	journalctl --since yesterday
	journalctl --since 09:00 --until \"1 hour ago\"

Common commands:
KERNEL:
	- shows the linux kernel logs, could be across boots:
		#> journalctl --catalog --lines=3000 --pager-end \"_TRANSPORT=kernel\"
	or
		#> journalctl --catalog --lines=3000 --pager-end -k

	- shows the linux kernel logs from last --boot:
		#> journalctl --catalog --lines=35000 --pager-end --boot -k
	- or from beginning:
		#> journalctl --catalog --boot -k
	- or from previous boot:
		#> journalctl --catalog --boot -1 -k
ALL:
	#> journalctl --catalog --lines=3000 --pager-end
FILTERED:
	#> journalctl --catalog --lines=3000 --pager-end --unit=sshd.service
	#> systemctl list-units --type=service # to get service
GREP:
	#> journalctl --catalog --lines=3000 --pager-end --grep \"port\" --priority 7

Section sys-docs"
	(syscall (str $(which journalctl))))

(alias ip
"
addr add - Add an address
	- Add address 192.168.1.1 with netmask 24 to device em1
	`ip addr add 192.168.1.1/24 dev em1`
addr del - Delete an address
	- Remove address 192.168.1.1/24 from device em1
	`ip addr del 192.168.1.1/24 dev em1`
addr - Display IP Addresses and property information (abbreviation of address)
	- Show information for all addresses
		`ip addr`
	- Display information only for device em1
		`ip addr show dev em1`
link - Manage and display the state of all network interfaces
	- Show information for all interfaces
		`ip link`
	- Display information only for device em1
		`ip link show dev em1`
	- Display interface statistics
		`ip -s link`
link set - Alter the status of the interface
	- Bring em1 online
		`ip link set em1 up`
	- Bring em1 offline
		`ip link set em1 down`
	- Set the MTU on em1 to 9000
		`ip link set em1 mtu 9000`
	- Enable promiscuous mode for em1
		`ip link set em1 promisc on`
route - Display and alter the routing table
	- List all of the route entries in the kernel
		`ip route`
route add - Add an entry to the routing table
	-Add a default route (for all addresses) via the local gateway 192.168.1.1 that can be reached on device em1
		`ip route add default via 192.168.1.1 dev em1`
	- Add a route to 192.168.1.0/24 via the gateway at 192.168.1.1
		`ip route add 192.168.1.0/24 via 192.168.1.1`
	- Add a route to 192.168.1.0/24 that can be reached on device em1
		`ip route add 192.168.1.0/24 dev em1`
route delete
	Delete a routing table entry
	ip route delete 192.168.1.0/24 via 192.168.1.1
	Delete the route for 192.168.1.0/24 via the gateway at 192.168.1.1
"
	(syscall (str $(which ip))))

(print-load-time "	after long lost documentation for system commands ")
;; }}}

;;; long live steve losh {{{
(print-load-time "	before long live steve losh")
	(alias pick
"display each argument and allow you to pick it or not. picks go to stdout.
see: man pick
Section: common-lisp"
	(syscall (str $(which pick))))

	(alias clhs
"get doc link from common lisp hyper spec
see: man clhs
Section: common-lisp"
	(syscall (str $(which clhs))))

	(alias example
"example cl program
see: man example
Section: common-lisp"
	(syscall (str $(which example))))

	(alias genpass
"generates random passwords
see: man genpass
Section: common-lisp"
	(syscall (str $(which genpass))))

	(alias json-string
"render content as json string
see: man json-string
Section: common-lisp"
	(syscall (str $(which json-string))))

	(alias lispindent
"need ~/.lispwords file and other stuff
see: man lispindent
Section: common-lisp"
	(syscall (str $(which lispindent))))

	(alias retry
"retry runs another command retries it if it returns non zero exit code
see: man retry
Section: common-lisp"
	(syscall (str $(which retry))))

	(alias subex
"An example sub command.
see: man subex
Section: common-lisp"
	(syscall (str $(which subex))))

	(alias batchcolor
"(batchcolor options regex [file...])
see: man batcholor
Section: common-lisp"
	(syscall (str $(which batchcolor))))

	(alias nix
"Explanation of nix commands:

	- q is for query that are --installed
		#> nix-env -q --installed
	- q is for query that are -a (available) named \"git\"
		#> nix-env -qa git

Section: user-shell"
	(syscall (str $(which nix))))

	(alias git-crypt
"good practice to list which files are encrypted `git-crypt status -e` 
based on .gitattributes files
that look like:

===
secrets.txt filter=git-crypt diff=git-crypt
*.key filter=git-crypt diff=git-crypt
secretdir/** filter=git-crypt diff=git-crypt
===

Section: user-shell"
	(syscall (str $(which git-crypt))))

(print-load-time "	after long live steve losh")
;;; }}}

(ns-auto-export 'shell-docs)
(ns-pop)
