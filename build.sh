#!/bin/zsh
DIST="${1:-./dist}"

mkdir -p $DIST/python

poetry export -f requirements.txt --without-hashes >requirements.txt

python3 -m pip install -r requirements.txt -t $DIST/python

zip -r $DIST/layer.zip $DIST/python
