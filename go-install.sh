#!/bin/bash

#
# Description: 	Install the Go programming language (>= 1.2.2)
#
# Author:	Jose G. Faisca <jose.faisca@gmail.com>
#
# Add /usr/local/go/bin to the PATH environment variable. 
# You can do this by adding this line to your /etc/profile 
# (for a system-wide installation) or $HOME/.profile:
#
# export PATH=$PATH:/usr/local/go/bin
#

# system architecture
ARCH="amd64"
# OS
OS="linux"
# go repository
REPO="https://storage.googleapis.com/golang"
# installation path
INSTALL_PATH="/usr/local/"
# go version
VERSION=$1
VERSION=${VERSION:-"1.10.2"}

if [ $# -eq 1 ]; then
   VERSION=$1
fi

# tar file
TAR_FILE="go$VERSION.$OS-$ARCH.tar.gz"
# URL
URL="$REPO/$TAR_FILE"

echo "Installing golang version $VERSION ..."

# download go
curl -O "$URL"

# remove previous extracted files
[ -d "$INSTALL_PATH/go" ] && sudo rm -rf $INSTALL_PATH/go

# uncompress to installation path
CMD="sudo tar -C $INSTALL_PATH -xvzf $TAR_FILE"
echo $CMD
eval $CMD && rm -f $TAR_FILE

# create dirs
mkdir -p $HOME/go
mkdir -p $HOME/work

# set environment
echo "export GOPATH=\$HOME\/work" >> $HOME/.bashrc
echo "export GOROOT=/usr/local/go" >> $HOME/.bashrc
echo "export PATH=\$GOROOT\/bin:\$PATH\" >> $HOME/.bashrc
source $HOME/.bashrc

# output version
go version

exit 0
