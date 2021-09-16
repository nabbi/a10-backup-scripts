#!/bin/bash
# copyright.c.2021.nic@boet.cc
# this proccess exports the running configs and saves locally

# define which hosts we need backups from
nodes= "a10host1a a10host1b a10host2a a10host2b"

# path to an existing git repo
repo="$HOME/a10-configs/"

cd $repo
for n in $nodes; do
	#this exports the running config on each part including aflex
	~/a10-backup-scripts/backup-running.exp $n ${n}.config > /dev/null

	if [ $? -ne 0 ]; then
		echo "error: unclean file from $n"
		git checkout ${n}.config
		logger -p user.warn "$0 error: unclean file from $n"
	fi

	#this scp exports the backup tar archive
	~/a10-backup-scripts/backup-scp.exp $n > /dev/null
	
    if [ $? -ne 0 ]; then
		echo "error: scp failed $n"
		logger -p user.warn "$0 error: scp failed $n"
	fi
	
done

#strip noise from outputs from appearing in git diffs
#-    Event HTTP_REQUEST         execute 28224 times (47 failures, 0 aborts)
#+    Event HTTP_REQUEST         execute 117 times (0 failures, 0 aborts)
sed -i '/Event\ HTTP_REQUEST/d' ./*.config

# add *.tar.gz into .gitignore to suppress tracking bin exports
git add ./*.config
git commit -m "cron: config backup"
logger -p user.info "$0 completed"
