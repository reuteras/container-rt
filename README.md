# container-rt

[RT](https://www.bestpractical.com/rt/), or Request Tracker, is a issue tracking system. Currently build RT latest (5.0.x) and RT 4.4.x.

This is a new version of my docker-rt version that used an external Postgresql. This is still alpha code and I only use it for testing.

## Requirements

In this first build this container makes some assumptions that might not be for everyone. The container is only built to use Postgresql. You also have to use SSL/TLS and have a directory with the following files shared with the container at startup:

* RT_SiteConfig.pm
* server-chain.pem
* server.pem

## Usage

## TODO

- Instruction for adding plugins.
- Backups? https://docs.bestpractical.com/rt/5.0.1/system_administration/database.html
- Automation? https://docs.bestpractical.com/rt/5.0.1/automating_rt.html
- Config? https://docs.bestpractical.com/rt/5.0.1/RT_Config.html
- Upgrade DB? https://docs.bestpractical.com/rt/5.0.1/UPGRADING-5.0.html
- Styling? https://docs.bestpractical.com/rt/5.0.1/customizing/styling_rt.html
- Security? https://docs.bestpractical.com/rt/5.0.1/security.html
- 
