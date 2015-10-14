#!/usr/bin/env bash

cd $HOME

if ! command -v zsh >/dev/null; then
  echo "You need to run the following prior to bootstrapping:"
  echo "  sudo apt-get -y install zsh"
  echo "  sudo chsh -s /bin/zsh $USER && zsh"
  exit
fi

mkdir -p bin src/{$USER,utils,thoughtbot} var

# install rcm
wget https://thoughtbot.github.io/rcm/debs/rcm_1.2.3-1_all.deb
sudo dpkg -i rcm_1.2.3-1_all.deb

# install dotfile dependent repos
git clone git@github.com:$USER/dotfiles.git src/trq/dotfiles
git clone git@github.com:thoughtbot/dotfiles.git src/thoughtbot/dotfiles
git clone git@github.com:olivierverdier/zsh-git-prompt.git src/utils/zsh-git-prompt

# install dotfiles
cd src/$USER/dotfiles && git checkout 2015-linux
cd $HOME
env RCRC=$HOME/src/$USER/dotfiles/rcrc rcup

# standard packages
sudo apt-get -y install \
  tree \
  watch \
  wget \
  curl \
  tmux \
  git-core \
  awscli \
  build-essential \
  python-software-properties \
  apt-get -y install silversearcher-ag \
  vim

# update default editor
sudo update-alternatives --all

# set ability to sudo without password
sudo visudo -f /etc/sudoers

# php
sudo apt-get -y install \
  php5-fpm \
  nginx \
  php5-intl \
  php5-mcrypt \
  php5-xdebug \
  php5-imagick \
  php5-cli \
  php5-curl \
  php5-gd \
  php5-redis

# mariadb
sudo apt-get -y install \
  mariadb \
  mariadb-server

sudo mysql_secure_installation

# redis
sudo apt-get -y install \
  redis \
  redis-server

# ruby
sudo apt-get -y install \
  zlib1g-dev \
  libssl-dev \
  libreadline-dev \
  libyaml-dev \
  libsqlite3-dev \
  sqlite3 \
  libxml2-dev \
  libxslt1-dev \
  libcurl4-openssl-dev \
  libffi-dev

git clone git://github.com/sstephenson/rbenv.git .rbenv
git clone git://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build

source .zshrc

git clone https://github.com/sstephenson/rbenv-gem-rehash.git .rbenv/plugins/rbenv-gem-rehash

rbenv install 2.2.3
rbenv global 2.2.3

# sass / compass
gem install compass

# pip
echo "deb http://archive.ubuntu.com/ubuntu/ vivid universe" | sudo tee -a "/etc/apt/sources.list"
sudo apt-get -y update
sudo apt-get -y install python-dev python-pip

# ansible & boto
sudo pip install -I ansible==1.8.4 boto

# saws (aws cli tool)
pip install saws

# node
curl -sL https://deb.nodesource.com/setup_0.12 | sudo -E bash -
sudo apt-get -y install nodejs
mkdir .npm-packages

# node packages
npm install -g uglifycss
npm install -g uglifyjs

# composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer

exit
