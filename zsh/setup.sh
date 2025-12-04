#!/usr/bin/env bash

# Function to display error messages
error() {
  echo "Error: $1" >&2
  exit 1
}

# Install antidote
if [ ! -d "${ZDOTDIR:-~}/.antidote" ]; then
  echo "Installing antidote, please wait..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
  if [ ! -d "${ZDOTDIR:-~}/.antidote" ]; then
    error "Failed to clone the antidote repository. Check this manually"
  else
    echo "antidote installed successfully."
  fi
fi
