#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" "$@"

# configuration file for the backend tcl expect scripts

## a10 device admin credentials
# enable is only used if we detect we are disabled
set config(username) {admin}
set config(password) {admin-password}
set config(enable) {[enable-password}

## scp backup server (THIS servers) credentials
# scp_host expects fqdn A record
# scp_path needs to be accessible by the process running this script
set config(scp_user) {linux-userid}
set config(scp_pass) {pass1234}
set config(scp_host) {server.hostname.fdqn}
set config(scp_path) "/home/$config(scp_user)/a10-configs"

