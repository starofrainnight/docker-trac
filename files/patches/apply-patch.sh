#!/bin/bash

PATCH_DIR=/tmp/patches

cd /usr/local/lib/python2.7/dist-packages/
patch -p1 < ${PATCH_DIR}/TracMasterTickets/0000-fixed-id-not-convert-to-str-correctly.patch