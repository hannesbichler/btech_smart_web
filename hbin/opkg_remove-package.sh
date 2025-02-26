#!/bin/bash
test -z "${1}" && exit 1
opkg --force-depends --force-remove --force-removal-of-dependent-packages --autoremove remove "${1}"
