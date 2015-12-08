#!/bin/bash

tracd -d --basic-auth="*,/srv/trac/passwd,Trac" -e /srv/trac
exec bash
