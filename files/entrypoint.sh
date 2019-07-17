#!/bin/bash

BASE_DIR="/srv/trac"
ENV_DIR="$BASE_DIR/.env"

if [ -d "$ENV_DIR" ]; then
    # Take action if $ENV_DIR exists
    echo "Python user virtual environment exists."
else
    echo "Python user virtual environment not exists! Creating ..."

    # Create virtualenv environment
    virtualenv --system-site-packages $ENV_DIR

fi

virtualenv --relocatable $ENV_DIR

source $ENV_DIR/bin/activate

python /usr/local/bin/tracd --basic-auth="*,$BASE_DIR/passwd,trac" -e $BASE_DIR
