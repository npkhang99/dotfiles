#!/bin/bash
pkgmgr="pacman"
sudo $pkgmgr -S $(cat install.txt) --needed
