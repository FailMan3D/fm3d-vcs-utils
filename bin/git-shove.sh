#!/bin/sh
git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"
