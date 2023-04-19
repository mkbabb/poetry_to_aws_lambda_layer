#!/bin/zsh

PYTHON_VERSION="${1:-3.9}"
DIST="${2:-./dist}"

mkdir $DIST/python

cp $3 $DIST/python

# Export the packages from poetry; install locally.
# No devevelopment dependencies.
poetry export -f requirements.txt --without-hashes >$DIST/requirements.txt
python3 -m pip install --platform=manylinux1_x86_64 --no-deps --python-version $PYTHON_VERSION -r $DIST/requirements.txt -t $DIST/python

cd $DIST
zip -r layer.zip python/

rm -rf python requirements.txt
