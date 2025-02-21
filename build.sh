#!/bin/zsh

# Default to Python 3.12
PYTHON_VERSION="${1:-3.12}"

# Default to ./dist
DIST="${2:-./dist}"

# Extra paths to include in the dist folder; args 3-n
EXTRA_PATHS="${@:3}"

# Create the dist folder
mkdir -p $DIST/python

# Copy the "extra_paths" into the dist/python folder.
for path in $EXTRA_PATHS; do
    cp -r $path $DIST/python
done

# Export the packages from poetry; install locally.

# No devevelopment dependencies.
poetry export -f requirements.txt --without-hashes >$DIST/requirements.txt
poetry run python3 -m pip install --platform=manylinux1_x86_64 --no-deps --python-version $PYTHON_VERSION -r $DIST/requirements.txt -t $DIST/python

cd $DIST
zip -r layer.zip python/

rm -rf python requirements.txt
