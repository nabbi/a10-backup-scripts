# A10 backup expect scripts
Performs device configuration backups on [A10 Networks Inc](https://www.a10networks.com/) Thunder SSLi appliances

Two types of exports are collected
- "backup system" tar files, for official device restores
- "show running-config" and "show aflex" from all partitions, for config audit monitoring and cli restores

I wrote this process because our commercial device config manager had trouble walking multiple partitions and failed to extract the aflex scripts.
Parts and Aflex are dynamically detected and saved into a local git repo
Unknown if A10 Networks aGalaxy fulfills this need, we didn't have it.

The scp exports provided yet another means for archiving a full device image. This served as a redundant copy as we used the appliances built in schedule backup export feature too.


# dependencies

Requires TCL Expect and BASH, and the following packages
- dig
- fping
- git
- logger


# setup

YMMV, should just need to initialize a new repo and maybe fiddle with the paths to suit your needs

> git clone https://github.com/nabbi/a10-backup-scripts ~/a10-backup-scripts

create git repo
> mkdir ~/a10-configs
> git init ~/a10-configs

Optionally create .gitignore to not track tar exports.
If you do want to commit these into the repo then the run.sh needs to be adjusted too
> echo "*.tar.gz" >> ~/a10-configs/.gitignore


# config

Two files need to be touched
- ./inc/config.tcl needs to be defined with device creds from config.example.tcl 
- ./run-a10-config-backups.sh needs the hostname list of a10 appliances to backup


# crontab

I run these just before midnight for a daily rollup of config changes.
> 45 23 * * * ~/a10-backup-scripts/run-a10-config-backups.sh  > /dev/null 2>&1

