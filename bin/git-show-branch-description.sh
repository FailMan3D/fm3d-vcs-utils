#!/usr/bin/env sh

LC_ALL=en_US.UTF-8

git config -l | egrep '^branch\..*\.description' \
  | sed 's/^branch\.\(.*\)\.description=\(.*\)/\1:\2/' \
  | awk -F: '{printf("\033[1;35m %40s\033[0m: %-s\n", $1, $2)}'
