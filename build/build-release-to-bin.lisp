#!/usr/bin/env sl-sh

(ns-import 'shell)

$(cargo build --release)
$(cp ./target/release/sl-sh ~/bin/sl-sh)
$(strip ~/bin/sl-sh)
