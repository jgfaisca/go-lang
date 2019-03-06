#!/bin/bash

#
# Description: Install the Go programming language (>= 1.2.2)
#
# Author:	Jose G. Faisca <jose.faisca@gmail.com>
#
# Add /usr/local/go/bin to the PATH environment variable. 
# You can do this by adding this line to your /etc/profile 
# (for a system-wide installation) or $HOME/.profile:
#
# export PATH=$PATH:/usr/local/go/bin
#

# operating system
UNAME=$(uname)
OS="null"
if [ "$UNAME" == "Linux" ] ; then
        OS=${UNAME,,}
elif [ "$UNAME" == "FreeBSD" ] ; then
        OS=${UNAME,,}
elif [ "$UNAME" == "Darwin" ] ; then
        OS=${UNAME,,}
else
       echo "invalid operating system $ARCH"
       exit 1
fi

# system architecture
HW=$(uname -m)
ARCH="null"
if [ "$HW" == "x86_64" ]; then
        ARCH="amd64"
elif [ "$HW" == "i386" ] || [ "$HW" == "i686" ]; then
        ARCH="386"
elif [ "$HW" == "armv6l" ]; then
        ARCH="armv6l"
elif [ "$HW" == "armv8l" ] || [ "$HW" == "armv8b" ]; then
        ARCH="arm64"
else
        echo "invalid architecture $ARCH"
        exit 2
fi

# go repository
REPO="https://storage.googleapis.com/golang"
# installation path
INSTALL_PATH="/usr/local"
# go version
VERSION=$1
VERSION=${VERSION:-"1.12"}

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

# set PATH and environment variables
cat $HOME/.bashrc | grep $INSTALL_PATH/go &> /dev/null
if [ $? -ne 0 ]; then
  echo " " >> $HOME/.bashrc
  echo "# Go programming language" >> $HOME/.bashrc
  echo "export GOPATH=\$HOME/go" >> $HOME/.bashrc
  echo "export GOROOT=$INSTALL_PATH/go" >> $HOME/.bashrc
  echo "export PATH=\$PATH:\$GOROOT/bin" >> $HOME/.bashrc
  source $HOME/.bashrc
fi

# print version
echo " "
$INSTALL_PATH/go/bin/go version
echo "GOPATH=$GOPATH"
echo "GOROOT=$GOROOT"

exit 0
