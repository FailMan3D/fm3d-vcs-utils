#!/bin/sh
git log --name-only --pretty=oneline "$1" \
	| egrep -v '^[[:xdigit:]]{40}' \
	| sort -u
