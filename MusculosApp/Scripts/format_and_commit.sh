#!/bin/sh

# Function to check if SwiftFormat is installed
check_swiftformat() {
  if ! command -v swiftformat &> /dev/null; then
    echo "SwiftFormat not found, installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
      echo "Homebrew is not installed. Please install Homebrew first."
      exit 1
    fi
    brew install swiftformat
  else
    echo "SwiftFormat is already installed."
  fi
}

# Function to get list of changed files
get_changed_files() {
  git diff --cached --name-only --diff-filter=ACM | grep '\.swift$'
}

# Check and install SwiftFormat if necessary
check_swiftformat

# Get the list of changed Swift files
changed_files=$(get_changed_files)

if [ -z "$changed_files" ]; then
  echo "No Swift files to format."
  exit 0
fi

config_path="MusculosApp/.swiftformat"

# Run SwiftFormat on each changed file
echo "Running SwiftFormat on changed files..."
for file in $changed_files; do
  swiftformat "$file" --config "$config_path" --swiftversion 6
done

# Optionally, add the formatted files to the commit
git add $changed_files

echo "SwiftFormat applied to changed files. You can now commit your changes."
