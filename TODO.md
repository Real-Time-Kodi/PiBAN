# Secure Erase Branch TODO list.
This branch is for much more than just implementaion of secure erase. Also included in this release will be detection of what
drives/enclosures support and select nuking method automatically based on this.

 - [ ] Detect drives' capabilites and reccomend secure erase.
 - [ ] Differentiate between Flash media such as SD cards and Sata Media.
 - [ ] Add a(n optional) verification pass to make sure that secure erase worked.
 - [ ] Create a whitelist for known working sata docks.
 - [ ] Create an option to override the whitelist.
 - [ ] Create a config file on /boot for easy reconfiguration without special tools.
