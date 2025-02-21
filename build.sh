#!/bin/zsh

# Default to Python 3.12
PYTHON_VERSION="${1:-3.12}"
# Default to ./dist
DIST="${2:-./dist}"

# Create the dist folder
mkdir -p $DIST/python

# Copy the "extra_paths" into the dist folder.
cp $3 $DIST/python

# Export the packages from poetry; install locally.

# No devevelopment dependencies.
poetry export -f requirements.txt --without-hashes >$DIST/requirements.txt
poetry run python3 -m pip install --platform=manylinux1_x86_64 --no-deps --python-version $PYTHON_VERSION -r $DIST/requirements.txt -t $DIST/python

cd $DIST
zip -r layer.zip python/

rm -rf python requirements.txt
