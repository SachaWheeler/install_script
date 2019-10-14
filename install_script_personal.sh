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
  erlang
  elixir
  heroku-toolbelt
  macvim
  postgres
  redis
  watchman
  valgrind
)

echo "Installing packages..."
brew install ${binaries[@]}

brew cleanup

brew tap caskroom/cask

# Apps
apps=(
  codekit
  dropbox
  firefox
  flux
  google-chrome
  keka
  ifunbox
  iterm2
  licecap
  nylas-n1
  psequel
  screenhero
  skype
  sketch
  slack
  spotify
  vlc
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

# echo "Running Janus Vim distribution bootstrap script..."
# curl -L https://bit.ly/janus-bootstrap | bash

###############################################################################
# Bash prompt setup (with git setup!)
###############################################################################

echo "Setting up ~/.bash_profile..."
touch ~/.bash_profile
curl https://gist.githubusercontent.com/rpearce/82dc9f6b96d1a04dcff5/raw/a3b0fdee46085fd26749594e4ebca7d08b39dcd3/.bash_profile > ~/.bash_profile

echo "Sourcing ~/.bash_profile"
. ~/.bash_profile

###############################################################################
# Ruby
###############################################################################

echo "Installing Ruby version 2.3.1..."

rbenv install 2.3.1
rbenv global 2.3.1
rbenv rehash

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

git clone https://github.com/SachaWheeler/vimrc.git ~/.vim
cp ~/.vim/vimrc ~/.vimrc
source ~/.vimrc

# install pip
pip install virtualenvwrapper

