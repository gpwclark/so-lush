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

(def graphics-docs "
which graphics cards/drivers are being used?

# $ glxinfo | grep -E \"OpenGL vendor|OpenGL renderer\"


Just type nvidia-smi in the terminal. Then check for the percentage of usage.
That will indicate which GPU is in us
	 ")

(def nvidia graphics-docs nil)
(def graphics graphics-docs nil)
(def graphics-doc graphics-docs nil)

(alias gdb "
       on gentoo, for sys-libs/glibc compile with debug symbols: 
		https://wiki.gentoo.org/wiki/Debugging
 " (syscall (str $(which gdb))))

(alias find "
	 exclude a path, e.g. find rust file not in target
		 - find . -path ./target -prune -o -iname \"*rs\"
 " (syscall (str $(which find))))

(def screensaver "
X.org has some basic screen saver functionality as well as energy saving features. Most likely either or both are responsible for the described behavior.

The settings for both can be viewed and changed with the xset tool (from the x11-xserver-utils package). xset q displays the current settings in the sections Screen Saver and DPMS (Energy Star).

You can disable the screen saver feature with:

xset s off
The power saving feature can be turned off with

xset -dpms
With these settings the screen should no longer turn off or blank automatically until you reboot your machine.

If your main concern is that 5 minutes are to short, you can also just raise the limits for that. To enable the screen saver only after 15 minutes (900 seconds) idle time, set the timeout accordingly with

xset s 900
To turn off the monitor after 20 minutes of idling run

xset dpms 0 0 1200
The two 0 values disable standby and suspend respectively, while 1200 sets the timeout for off to 20 minutes. (I usually do not use standby or suspend because there seems to be no difference between the three modes on modern TFT-displays.) Setting these values also enables DPMS, so you do not need to explicitly run xset +dpms.
	 " nil)

(def gentoo "Gentoo!
     	 ;; Cheat sheet https://wiki.gentoo.org/wiki/Gentoo_Cheat_Sheet
	 (doc equery) ;; probe system for information about system/packages
	 (doc qlist)  ;; list intsalled files
	 (doc e-file) ;; thru hardwork of `pfl` pkg, search for a file/binary and this will tell you which packages have it.
	 (doc emerge) ;; main portage cli tool
	 (doc eix)     ;; a feature rich wrapper for managing custom repos
	 (doc eselect) ;; manage current configuration of system (eselect [repository|locale|etc] ...,).
	 (doc gentoo-custom-repos) ;; Manage custom repos
	 (doc dispatch-conf) ;; Portage utility used to safely and conveniently manage configuration files after package updates.
	 (man portage) ;; The ❤️ of Gentoo. A glossary of terms and list of files associated with the mighty portage ⚓!
 " nil)

(def systemd "Systemd
     	 ;; Cheat sheet https://wiki.gentoo.org/wiki/Gentoo_Cheat_Sheet
	 (doc systemctl) ;; control services
	 (doc journalctl)  ;; view logs
	 (doc systemd-analyze) ;; some niche useful commands
	 (doc systemctl-user) ;; notes on doing things at the user level
 " nil)

(def gentoo-custom-repos
	 "
	 # Install sanoid & syncoid
amd64:# echo \"~sys-fs/sanoid-2.2.0\" >> /etc/portage/package.accept_keywords/sys-fs
arm64:# echo \"~sys-fs/sanoid-2.2.0 **\" >> /etc/portage/package.accept_keywords/sys-fs
# echo \"~dev-perl/Config-IniFiles-3.0.3::gentoo **\" >> /etc/portage/package.accept_keywords/dev-perl

// there are some repositoryies that are set up through... I think it is eix, but you can easily make your own 
// see below

// prereq
amd64 & arm64:# emerge -avu -j 4 eselect-repository
// actual commands
# eselect repository enable vowstar
# eix-sync OR emerge --sync #must do!
# emerge -avu -j 4 sanoid app-admin/sudo
# or 
# emerge -avuDN -j 4 media-sound/pamixer::menelkir

// # to add a brand new repository
1. sudo eselect repository add pingwho-overlay git https://ftp.pingwho.org/pub/gentoo/ftp/overlay/pingwho-overlay
2. which updates the file /etc/portage/repos.conf/eselect-repo.conf w/ specific information that is editable.
3. sudo emaint sync -r pingwho-overlay // to sync w/ that ebuild repo
4. then sync w/ it: eix-update
5. then search for packages in the new overlay: eix -R some package
 "
	 nil)


(alias dispatch-conf
	"
	https://wiki.gentoo.org/wiki/Handbook:AMD64/Portage/Tools#dispatch-conf

	interactively update config changes
	"
	(syscall (str $(which dispatch-conf))))


(alias eselect
	"
	- read the news! very helpful stuff!
		- eselect news read
	- setting the locale
		eselect locale list
		eselect locale set <X> # where X is some number from `locale list`
		locale -a # /etc/locale.conf is what ends up changed
	- enable a new repo
		eselect repository enable vowstar
	- font config,
		eselect fontconfig
	"
	(syscall (str $(which eselect))))

(alias qlist
   "qlist -IRv list installed packages with version number and name of overlay used:"
	   (syscall (str $(which qlist)))


(alias equery
	"PACAKGE INTROSPECTION
	cheat sheet: https://wiki.gentoo.org/wiki/Gentoo_Cheat_Sheet

	list installed packages with version number and name of overlay used:
		`qlist -IRv`
	what versions are installed?:
		`equery y webkit-gtk`
			shows keywords enabled for package but also details versions of said
			package installed (and all available versions),
			which repos those versions came from etc.
		`equery list -po webkit-gtk` # simpler
		`equery list webkit-gtk
	Finding the package that a file came from with belongs (b)
		`equery belongs -e /usr/bin/glxgears`
	Listing files installed by a package with files (f)
		`equery files --tree gentoolkit`
	"
	(syscall (str $(which equery))))

(alias eix
	"FULLTEXT:
To view the list of packages in the world set, along with their available versions, it is possible to use eix:
	eix --color -c --world | less -R

I was just looking for the very same thing. If you use eix, you are in luck.

From the wiki:
Adding overlays to the cache

To search not only in the portage tree but all the overlays, add overlays to the cache

root # eix-remote update

and then sync it all:

root # eix-sync

(example from my system)

 $ eix nuvola
* x11-themes/nuvola
  Available versions:  1.0-r1^bs
  Homepage:            http://www.kde-look.org/content/show.php?content=5358
  Description:         Nuvola SVG icon theme

Hmm that doesn't look like a google music player ... time to add some more sources:

 $ eix-remote update
<snip>
Saving to: 'eix-cache.tbz2'
* Unpacking data
layman/Armageddon -> Armageddon
layman/AstroFloyd -> AstroFloyd
 layman/AzP -> AzP
<snip>

looks like about 500 sources :)

root # eix-sync -q

Now when searching, if you wish to expand your search, add -R (remote) to search all overlays, installed or not. You will want to sync it with eix-remote from time to time. See man eix.

 $ eix -R nuvola
* media-sound/nuvolaplayer
 Available versions:  (~)2.0.1[2] (~)2.0.3[1] {debug}
 Homepage:            https://launchpad.net/nuvola-player
 Description:         Cloud music integration for your Linux desktop

* x11-themes/nuvola
 Available versions:  1.0-r1^bs
 Homepage:            http://www.kde-look.org/content/show.php?content=5358
 Description:         Nuvola SVG icon theme

[1] \"sabayon\" layman/sabayon
[2] \"tante\" layman/tante



	OVERLAYS OH MY
		add overlays to your cache with
			`eix-remote update`
		then sync
			`eix-sync`
		maybe update?
			`eix-remote update`
		maybe quiet sync again?
			`eix sync -q`
		search for packages installed OR not from the world's overlays
			`eix -R webkit-gtk`
		list all overlay installed packages on system
			eix -J
	"
	(syscall (str $(which eix))))

(alias emerge
	"
	emerge -s thing-to-search
	emerge -avuDN -j 5 package # ask verbose update deep newuse, with 5 cores for spawned processes
	emerge -avuDN -j 5 @world # after updating USE flags or various /etc/portage/make.conf stuff or emerge --sync run this to update/rebuild software
	emerge --sync # get new stuff!
	emerge --deselect media-tv/v4l-utils to remove package from world file to then remove from the system when @world is updated. (preferred way to remove packages).
	# finding files that aren't on your box
		- do not forget about `pfl`!  Portage File List (PFL) can be used to search for files (or strings) provided by
		packages that are not currently installed on a given system. This can be useful to find out what package to install
		given the name of a file from a desired tool. Optionally, the PFL tool can update the online PFL database from the
		list of locally installed files.
		e.g.
		e-file `pamixer`
	"
	(syscall (str $(which emerge))))


(alias zfs
	"
	- check free space
		`zpool list`
	- listing snapshots
		- ls /.zfs # is where all the snapshots are stores
		- zfs list -t all
	- create a dataset (specify a mountpoint for sanity reasons)
		+ zfs create -o mountpoint=/mnt/hdd -o canmount=noauto zhdd/root
	- mount a dataset
		+ zfs mount zhdd/root
	- check mountpoint(s)
		+     for all pools | 		      one dataset | more specific datasets
		+ zfs get mountpont | zfs get mountppoint -r zhdd |  zfs get mountppoint -r zhdd/root
	- auto importing datasets on startup (for zpool zdata) store in a cache file on the boot (unencrypted) partition.
		+ `zpool set cachefile=/etc/zfs/zpool.cache zdata`
	- [Creating a new zfs partition on some harddrive start to finish.](https://www.howtogeek.com/175159/an-introduction-to-the-z-file-system-zfs-for-linux/)
		```
		zfs list # should be no datasets other than maybe your computer's if you're on zfs
		# optional / i'm not sure make sure the harddrive you want to zfs has no partition table
		# Let's start by taking three of our hard disks and putting them in a storage pool by running the following command: 
		sudo zpool create -f geek1 /dev/sdb /dev/sdc /dev/sdd
		#           ^      ^ ^     ^
		#           |      | |     |
		#           |      | |     - the disks we're adding to the pool
		#           |      | - the name of the partition
		#           |      | |
		#     create cmd   - overrides errors e.g. if the disk already has data
		
		# verify you can see the pool with
		df
		# or
		zfs list
		# If you want to see which three disks you selected for your pool, you can run
		sudo zpool status
		```
	"
	(syscall (str $(which zfs))))


(alias zpool
	"
	zpool status
	zpool import zbrumal
	zpool export
	"
	(syscall (str $(which zpool))))

(alias syncoid
	"
	source: https://klarasystems.com/articles/improving-replication-security-with-openzfs-delegation/
	
	1. remote backup 1: on brumal, backup frostig
	================================
		syncoid likes pulls, so we want this to work:
		```
		brumal$ syncoid --delete-target-snapshots --no-sync-snap --no-privilege-elevation frostig:zfrostig/root zbrumal/backup/zfrostig/root
		```
		which reqiures some permissions namely. brumal, the receiver needs rollback permissions
		brumal# zfs allow price rollback zbrumal/backup/zfrostig
		frostig# zfs allow price hold zfrostig/root

	2. remote backup 2: on frostig, backup brumal by pulling files from brumal
	================================
		```
		frostig$ syncoid --delete-target-snapshots --no-sync-snap --no-privilege-elevation brumal:zbrumal/root zfrostig/backup/zbrumal/root
		```
	3. the two local backups:
	=========================
		```
		# backups the brumal snapshots that are on frostig
		frostig$ syncoid --delete-target-snapshots --no-sync-snap --no-privilege-elevation zfrostig/backup/zbrumal/root zbackup/zbrumal/root
		# backups the frostig snapshots
		frostig$ syncoid --delete-target-snapshots --no-sync-snap --no-privilege-elevation zfrostig/root zbackup/zfrostig/root
		```
	4. systemd timers for brumal:
	=============================
		- brumal is responsible for remote backups of frostig, this means it occosionally wakes up to pull files from frostig:
		`syncoid --delete-target-snapshots --no-sync-snap --no-privilege-elevation frostig:zfrostig/root zbrumal/backup/zfrostig/root`
		```file:~/.config/systemd/user/syncoid.service
		[Unit]
		Description=Backup ZFS Snapshots of frostig

		[Service]
		Environment=TZ=UTC
		Type=oneshot
		ExecStart=/bin/syncoid --delete-target-snapshots --no-sync-snap --no-privilege-elevation frostig:zfrostig/root zbrumal/backup/zfrostig/root
		```
		```file:~/.config/systemd/user/syncoid.timer
		[Unit]
		Description=Run Syncoid Every 59 Minutes

		[Timer]
		OnCalendar=*:0/59
		Persistent=true

		[Install]
		WantedBy=timers.target

		```
		# to enable
		$systemctl --user enable syncoid.timer
		$systemctl --user start syncoid.timer
		# to monitor 
		$journalctl --user -e -f
		
	5. systemd timers for frostig:
	=============================
		```file:~/.config/systemd/user/syncoid.service
		[Unit]
		Description=Backup ZFS Snapshots of brumal and brumal/zfrostig roots to zbackup

		[Service]
		Environment=TZ=UTC
		Type=oneshot
		ExecStart=/bin/syncoid --delete-target-snapshots --no-sync-snap --no-privilege-elevation brumal:zbrumal/root zfrostig/backup/zbrumal/root
		ExecStart=/bin/syncoid --delete-target-snapshots --no-sync-snap --no-privilege-elevation zfrostig/root zbackup/zfrostig/root
		ExecStart=/bin/syncoid --delete-target-snapshots --no-sync-snap --no-privilege-elevation zfrostig/backup/zbrumal/root zbackup/zbrumal/root
		```
		```file:~/.config/systemd/user/syncoid.timer
		[Unit]
		Description=Run Syncoid Every 59 Minutes

		[Timer]
		OnCalendar=*:0/59
		Persistent=true

		[Install]
		WantedBy=timers.target
		```
	

	TROUBLESHOOTING SUDO-less REMOTE:
	================
	- permissions for sending (computer being backed up) might be needed on the remote:
		remote$ sudo zfs allow $USER send zremote/root
	- permissions for  might be needed on the remote:
		local$ sudo zfs allow $USER create,mount,receive,destroy zlocal/backup
	
	"
	(syscall (str $(which syncoid))))

(alias sanoid
	"
	this does snapshotting, to set it up use:
	https://github.com/jimsalterjrs/sanoid/blob/master/INSTALL.md
	```file:/usr/lib/systemd/system/sanoid.timer
	[Unit]
	Description=Run Sanoid Every 15 Minutes

	[Timer]
	OnCalendar=*:0/15
	Persistent=true

	[Install]
	WantedBy=timers.target
	```
	sudo systemctl enable sanoid.timer

	```file:/etc/sanoid/sanoid.conf
	# you can also handle datasets recursively in an atomic way without the possibility to override settings for child datasets.
       [zlocal/root]
       frequently = 32
       hourly = 36
       daily = 60
       monthly = 24
       yearly = 10
	```
	"
	(syscall (str $(which sanoid))))

(def zfshelp "
	 (doc zfs)
	 (doc zpool)
	 (doc zfshelp)
	 (doc syncoid)
	 (doc sanoid)
	 (doc zfs-snapshots)
- zfs automount
	+ https://superuser.com/questions/1561274/how-to-i-automatically-mount-a-zfs-pool-on-an-external-drive-automatically-on-bo
	-Found the instructions in the Archlinux wiki. Since I had ZFS as root on this I actually could skip some of the steps - ZED is already set up on my system.

		zed will populate and automount the pool for me if there's a suitable configuration file. I created an empty file

		touch /etc/zfs/zfs-list.cache/storage

		ZED didn't pick it up and populate it so I gave it a kick by disabling and enabling a pool
		sudo zfs set canmount=off storage
		sudo zfs set canmount=on storage

		I rebooted the system and checked to see if its mounted and it was.
-ZFS broken disk
	terel ~ # zpool status
	  pool: zterel
	 state: DEGRADED
	status: One or more devices could not be used because the label is missing or
			invalid.  Sufficient replicas exist for the pool to continue
			functioning in a degraded state.
	action: Replace the device using 'zpool replace'.
	   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-4J
	  scan: resilvered 250M in 00:00:01 with 0 errors on 
	config:

		NAME                      STATE     READ WRITE CKSUM
		zbrumal                   DEGRADED     0     0     0
		  mirror-0                DEGRADED     0     0     0
			zbrumal0              ONLINE       0     0     0
			xxxxxxxxxxxxxxxxxxxx  UNAVAIL      0     0     0  was /dev/mapper/zbrumal1
	To try to use the drive again as is (perhaps the missing drive was simply no decrypted):
		# zpool-reopen
	Format the replacement drive:
		# fdisk /dev/___
	Encrypt the partition:
		# cryptsetup ...
	Mount the partition decrypted:
		# cryptsetup open /dev/mapper/zhostX zhostX
	Replace the unavailable device:
		# zpool replace zbrumal xxxxxxxxxxxxxxxxxxxx /dev/mapper/zbrumal1

	 " nil)

(def zfs-snapshot "
	 # to list snapshots
		 - zfs list -r -t snapshot -o name,creation zbackup
	" nil)

(alias openssl
	"
	simple way to encrypt a file:
		openssl des3 < youfile.txt > yourfile.txt.des3
		openssl des3 -d < yourfile.txt.des3 > yourfile.txt.decrypted
	"
	(syscall (str $(which openssl))))

(alias flox
	"
	https://flox.dev/docs/tutorials/creating-environments/
	https://etorreborre.blog/why-you-should-flox-every-day
	https://flox.dev/blog/extending-flox-with-nix-flakes/
	"
	(syscall (str $(which flox))))

(alias wget
	"
	to get a whole site...
	wget --mirror --convert-links --adjust-extension --page-requisites --no-parent https://doc.rust-lang.org/book/
	* --mirror – Makes (among other things) the download recursive.
	* --convert-links – convert all the links (also to stuff like CSS stylesheets) to relative, so it will be suitable for offline viewing.
	* --adjust-extension – Adds suitable extensions to filenames (html or css) depending on their content-type.
	* --page-requisites – Download things like CSS style-sheets and images required to properly display the page offline.
	* --level=inf: No limit on recursion depth
	* --page-requisites: Get all resources needed to display pages properly
	* --html-extension: Save files with .html extension
	* --convert-links: Convert links to work locally
	* --domains: Stay within the provided domain
	* --no-parent: Don't go to parent directories
	* --no-clobber: Don't overwrite existing files
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
nix		| nix						| git@github.com:gpwclark/nix.git
-------------------------------------------------------------------------------------------------------------------
so-lush		| slush scripts for price			| git@github.com/gpwclark/so-lush.git
-------------------------------------------------------------------------------------------------------------------
vim		| vim						| git@github.com:gpwclark/vim.git
-------------------------------------------------------------------------------------------------------------------
secrets	| shhhh						| git@bitbucket.org:price_clark/secrets.git
-------------------------------------------------------------------------------------------------------------------
zsh		| zsh PLUS everything else I want, e.g. inputrc	| git@github.com:gpwclark/zsh.git
		| , environment initalization scripts, etc.	|
===================================================================================================================

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

90% of what you'll be doing.
1. vcsh foreach add -u # add changed tracked files
2. vcsh foreach status -uno` # to ignore untracked files
3. vcsh foreach diff --cached # only show tracked changes diffs
3. vcsh foreach commit -am yolo # technically
3. vcsh foreach push origin main

5%
1. vcsh enter <name-of-repo>
2. DO NOT forget to exit afterwards!

3%
# which files have changed
1. vcsh foreach status -uno

2%
# which files are being tracked by this branch
1. vcsh foreach files-on-branch main

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

(def unicodes "
	 ε - 03b5
" nil)

(alias vim
"
- how to insert unicode character:
	Ctrl+q + u then the 4 digit code then enter (e.g. 03B5 for ε)
	Ctrl+q + U then the longer code (if longer than digit unicode sumbol) then enter
	- how to replace something with a newline in vim.
		:set magic
		:%s/{/{^M/g
		To get the ^M character, type Ctrl + V and hit Enter
		Section: sys-docs

		- how tocopy and paste into vim
			hit ':' and in cmd window enter `r cat!`
			hit enter once or twice until cursor moves down (i think this is required) 
			and then paste into the now enlarged cmd window.
			hilariously you hit ctrl-d to then write this content into the buffer.

		- negative lookahead, e.g. find string abc that is NOT followed by defg:
			/abc \(defg\)\@!
			for more info: :help \@!

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

- write all tmux scrollback to file

    1.Use prefix + :, then type in capture-pane -S -3000 + Return. (Replace -3000 with however many lines you'd like to save, or with - for all lines.) 
	2. This copies those lines into a buffer.
    3. Then, to save the buffer to a file, just use prefix + : again, and type in save-buffer filename.txt + return. (by default it'll save the file in ~/)


Section: tmux"
	(syscall (str $(which tmux))))

(alias systemd-analyze
"to see where systemd unit/timer files are allowed to go:
systemd-analyze --user unit-paths"
	(syscall (str $(which systemd-analyze))))

(def systemctl-user " all systemctl commands can be given the --user flag but they need the following command
     to be run as sudo so that all user-level services are started properly:
sudo loginctl enable-linger $USER
" nil)

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
	- by a service
		#> journalctl --catalog --lines=3000 --pager-end --unit=sshd.service
	- or follow
		#> journalctl -e -u systemd-resolved -f
	- query list of services
		#> systemctl list-units --type=service # to get service
	- change log level by service name
		#> systemctl service-log-level systemd-resolved debug
GREP:
	#> journalctl --catalog --lines=3000 --pager-end --grep \"port\" --priority 7

Section sys-docs"
	(syscall (str $(which journalctl))))

(def systemd.timer "Systemd timers
	- Save these files as ~/.config/systemd/user/some-service-name.*
	- Run this now and after any modifications: systemctl --user daemon-reload
	- Try out the service (oneshot): systemctl --user start some-service-name
	- Check logs if something is wrong: journalctl -u --user-unit some-service-name
	- Start the timer after this user logs in: systemctl --user enable --now some-service-name.timer
file: some-service-name.service
```
[Unit]
Description=Do some thing
After=network.target

[Service]
Type=oneshot
WorkingDirectory=%h
ExecStart=%h/my-service/script.py --some-arg=some-value

[Install]
WantedBy=default.target
```

file: some-service-name.timer
```
[Unit]
Description=Run Do some thing every 30 minutes

[Timer]
OnBootSec=3min
OnUnitActiveSec=30min

[Install]
WantedBy=timers.target
```

 " nil)

(alias ip
"
3. [Temporary Static IP via ip](jetbrains.com/help/rust/rust-switch-debuggers-and-renderers.html)

$ ip address flush dev eth1
$ ip route flush dev eth1
$ ip address add 192.168.6.66/24 brd + dev eth1
$ ip route add 192.168.6.1 dev eth1
$ ip route add default via 192.168.6.1 dev eth1
$ ip address show dev eth1
[...]
    inet 192.168.6.66/24 brd 192.168.6.255 scope global eth1
[...]
Copy
After flushing all addresses and routes from eth1, we add a new static address and gateway. Next, we verify the settings by confirming that dynamic is no longer present in the interface characteristics. However, a system reboot now would wipe our network setup and restore the IP to what DHCP provides.

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
	help: https://checkoway.net/musings/nix/

	- q is for query that are --installed
		#> nix-env -q --installed
	- q is for query that are -a (available) named \"git\"
		#> nix-env -qa git

	-i is for install
		#> nix-env -irf ~/.config/nix/hiemal.nix

Section: user-shell"
	(syscall (str $(which nix))))

(alias git
"-apply patch from commit(s):
	- git format-patch -<n> <rev>
	- git format-patch -1 HEAD
	-1 is number of commits, so this is 1 starting at head.

	to apply: git am < file.patch
"
 (syscall (str ($which git))))

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

	(alias rustup
"
List Installed: 
	- rustup toolchain list
Install specific version of toolchain on host:
	- rustup toolchain install 1.79.0-x86_64-unknown-linux-musl
List all toolchains:
	- rustc --print=target-list
Add new toolchain
	- rustup target add x86_64-unknown-linux-musl
check if new update exists:
	- rustup check
update current stable:
	- rustup update stable
change to nightly toolchain:
	- rustup default nightly

Section: user-shell"
	(syscall (str $(which rustup))))

	(alias rg
"
(Looking for string \"search\")

- Exclude a directory from rg search
	rg -g \"!legacy/**\" \"search\"
- Match files with specific type
	rg -t toml \"search\"

Section: user-shell"
	(syscall (str $(which rg))))

(alias startx
	"
	/etc/X11/xorg.conf can be used to hardcode/override wrong stuff
	https://download.nvidia.com/XFree86/Linux-x86_64/304.137/README/xconfigoptions.html
	sudo nvidia-xconfig --prime # to generate a dumb /etc/X11/xorg.conf
	"
	(syscall (str $(which wget))))


(print-load-time "	after long live steve losh")
;;; }}}

(ns-auto-export 'shell-docs)
(ns-pop)
