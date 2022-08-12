#!/bin/zsh
DIST="${1:-./dist}"

mkdir -p $DIST/python

cp $2 $DIST/python

# Export the packages from poetry; install locally.
# No devevelopment dependencies.
poetry export -f requirements.txt --without-hashes >$DIST/requirements.txt
python3 -m pip install --platform=manylinux1_x86_64 --only-binary=:all: -r $DIST/requirements.txt -t $DIST/python
rm $DIST/requirements.txt

zip -r $DIST/layer.zip $DIST/python
