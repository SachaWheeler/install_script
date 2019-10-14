#!/bin/sh

###############################################################################
# Homebrew
###############################################################################

echo "Installing command line utilities"

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# terminal utils
binaries=(
  coreutils # Install GNU core utilities (those that come with OS X are outdated)
  findutils # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
  bash # Install Bash 4
  python
  pip
  ack
  git
  node
  npm
  hub
  rbenv
  ruby-build
  heroku-toolbelt
  macvim
  postgres
)

echo "Installing packages..."
brew install ${binaries[@]}

brew cleanup

brew tap caskroom/cask

# Apps
apps=(
  codekit
  firefox
  flux
  google-chrome
  iterm2
  psequel
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "Installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

###############################################################################
# Editor
###############################################################################

echo "Setting Git to use VIM as default editor..."
git config --global core.editor "vim"

###############################################################################
# Bash prompt setup (with git setup!)
###############################################################################

echo "Grabbing bash, git and settings"
# bash / git settings
git clone https://github.com/SachaWheeler/bash_settings.git ~/.bash-git-prompt
cp ~/.bash-git-prompt/bash_login ~/.bash_login
cp ~/.bash-git-prompt/bash_profile ~/.bash_profile
cp ~/.bash-git-prompt/bashrc ~/.bashrc

echo "Sourcing ~/.bash_profile"
. ~/.bash_login
. ~/.bash_profile
. ~/.bashrc

###############################################################################
# Set up PostgreSQL database
###############################################################################

echo "Starting Postgres..."
brew services start postgresql

echo "Creating default Postgres DB..."
createdb

###############################################################################
# Git Auto-Completion
###############################################################################

echo "Downloading git-completion script"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
source ~/.git-completion.bash

###############################################################################
# Git Config & SSH Key Generation
###############################################################################

echo "Setting up Git Config and SSH Key Gen"

git config --global user.name "Sacha Wheeler"
git config --global user.email "sacha@sachawheeler.com"
ssh-keygen -t rsa -C "sacha@sachawheeler.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
pbcopy < ~/.ssh/id_rsa.pub

echo "Now go online to GitHub.com > Settings > SSH & GPG Keys > New SSH Key and paste in the copied public key"
echo "***************"
echo "Make sure to create a new GitHub token, as well, and use that as your CLI GitHub Password"

echo -n "Hit any key to continue: "
read key

echo "Grabbing vim and settings"
# vim settings
git clone https://github.com/SachaWheeler/vimrc.git ~/.vim
cp ~/.vim/vimrc ~/.vimrc
source ~/.vimrc

# install pip
pip install virtualenvwrapper
mkvirtualenv sacha

