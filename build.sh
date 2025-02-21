#!/bin/bash

# This script builds a Python Lambda Layer for AWS, packages it into a zip file,
# and includes optional extra paths provided as arguments.

# Set the Python version to 3.13 by default, overridden by the first argument
PYTHON_VERSION="${1:-3.13}"

# Set the distribution directory to ./dist by default, overridden by the second argument
DIST="${2:-./dist}"

# Collect all extra paths from arguments 3 onwards into an array
EXTRA_PATHS=("${@:3}")

# Log the start of the build process with key details
echo "Building Python $PYTHON_VERSION Lambda Layer in $DIST with extra paths: ${EXTRA_PATHS[*]}"

# Create the distribution directory and a 'python' subdirectory to hold the layer contents
mkdir -p "$DIST/python"

# Clear out any existing files in the distribution directory
echo "Clearing existing files in $DIST"
rm -rf "$DIST"/*

# Export project dependencies from Poetry to a requirements.txt file
# Excludes development dependencies and hashes for simplicity
echo "Exporting dependencies from Poetry to $DIST/requirements.txt"
poetry export -f requirements.txt --without-hashes --without dev >"$DIST/requirements.txt"

# Install the dependencies into the dist/python directory using pip
# Configured for AWS Lambda compatibility (manylinux1_x86_64 platform)
echo "Installing dependencies into $DIST/python"
poetry run python3 -m pip install \
    --platform=manylinux1_x86_64 \
    --no-deps \
    --python-version "$PYTHON_VERSION" \
    -r "$DIST/requirements.txt" \
    -t "$DIST/python"

# Change to the distribution directory for zipping
cd "$DIST" || {
    echo "Error: Failed to change to $DIST"
    exit 1
}

# Copy each extra path into the dist/python directory, with logging and basic validation
for path in "${EXTRA_PATHS[@]}"; do
    if [ -e "$path" ]; then
        echo "Copying $path to $DIST/python"
        cp -r "$path" "$DIST/python"
    else
        echo "Warning: $path does not exist and will be skipped"
    fi
done

# Package the python directory into a layer.zip file
echo "Packaging python directory into layer.zip"
zip -r layer.zip python/

# Clean up temporary files (python directory and requirements.txt)
echo "Cleaning up temporary files"
rm -rf python requirements.txt

# Log completion and output location
echo "Build complete. Lambda Layer is available at $DIST/layer.zip"
