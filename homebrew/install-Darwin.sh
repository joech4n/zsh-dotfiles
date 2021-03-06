#!/usr/bin/env bash
# Homebrew
# based on https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# For Cask per https://github.com/caskroom/homebrew-cask/blob/master/USAGE.md
# --appdir=/my/path changes the path where the symlinks to the applications (above) will be generated. This is commonly used to create the links in the root Applications directory instead of the home Applications directory by specifying --appdir=/Applications. Default is ~/Applications.
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Ask for the administrator password upfront.
echo "  Installing Homebrew packages for you. Running: sudo -v"
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install from Brewfile
brew bundle -v

if [ ! -e /usr/local/bin/sha256sum ]; then
  echo "  Linking /usr/local/bin/sha256sum -> /usr/local/bin/gsha256sum for you."
  sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum
fi

# Specific versions of software
brew tap caskroom/versions
brew cask install textexpander3 || true && echo "This cask may have been removed per https://github.com/caskroom/homebrew-versions/pull/1300, if this fails, try installing from https://cdn.smilesoftware.com/TextExpander_3.4.2.zip"

echo "Homebrew packages installed!"

exit 0
