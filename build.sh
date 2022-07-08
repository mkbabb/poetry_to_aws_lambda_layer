#!/bin/zsh
DIST="${1:-./dist}"

mkdir -p $DIST/python

# Export the packages from poetry; install locally.
# No devevelopment dependencies.
poetry export -f requirements.txt --without-hashes >$DIST/requirements.txt
python3 -m pip install $DIST/requirements.txt -t $DIST/python
rm $DIST/requirements.txt

zip -r $DIST/layer.zip $DIST/python $2
