#!/bin/bash -x


function install_node {
  local version=${1:-"$NODE_VERSION"}
  local version=${version:-"8.4.0"}

  local arch=${2:-"$NODE_ARCH"}
  local arch=${arch:-"linux-x64"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f node-v${version}-${arch}.tar.xz ]] \
    && wget http://nodejs.org/dist/v${version}/node-v${version}-${arch}.tar.xz
  popd
  
  # make sure all necessary tools are installed
  if [ ! \( -e "$(which wget)" -a -e "$(which bsdtar)" \) ] ;then
    echo apt-get install wget bsdtar xz-utils -y
    sudo apt-get install wget bsdtar xz-utils -y
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && bsdtar -xf ~/Downloads/node-v${version}-${arch}.tar.xz

  echo $tools/node-v${version}-${arch}
}


export NODE_HOME=$(install_node $*) \
  && export PATH=$PATH:${NODE_HOME}/bin \
    && npm install npm@latest -g \
    && npm install -g @angular/cli \
    && npm ls -g --depth=0
