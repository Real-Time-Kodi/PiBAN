hdparm --user-master u --security-set-pass "password" "$1"
time hdparm --user-master u --security-erase "password" "$1"
