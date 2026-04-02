#!/usr/bin/env sh

shared="/var/home"

rm -rf $shared/folder-1
rm -rf $shared/folder-2

sysadminctl -deleteUser user-1
sysadminctl -deleteUser user-2
sysadminctl -deleteUser user-3

dseditgroup -o delete folder-1-read
dseditgroup -o delete folder-2-read
