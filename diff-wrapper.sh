#!/bin/sh

#diff is called by git with 7 parameters:
# path old-file old-hex old-mode new-file new-hex new-mode

kdiff3 --L1 "$1 (A)" --L2 "$1 (B)" "$2" "$5" | cat
#meld --L1 "$1 (A)" --L2 "$1 (B)" "$2" "$5" | cat

