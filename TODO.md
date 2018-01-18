# Secure Erase Branch TODO list.
This branch is for much more than just implementaion of secure erase. Also included in this release will be detection of what
drives/enclosures support and select nuking method automatically based on this.

 - [x] Detect drives' capabilites and reccomend secure erase.
 - [x] Differentiate between Flash media such as SD cards and Sata Media.
 - [x] Create a whitelist for known working sata docks.
 - [ ] Check that whitelist against the actual drive in question
 - [x] Create a config file on /boot for easy reconfiguration without special tools.
 - [x] Kill shred if drive removed.
 - [x] Convert to systemD service.
 - [x] Remove CRON dependancy
