#!/usr/bin/env sh
VER=v1.0.1
DIR=~/Downloads
MIRROR=https://github.com/kubernetes/minikube/releases/download/$VER

dl()
{
    OS=$1
    PLATFORM=$2
    wget -O $DIR/minikube-$VER-$OS-$PLATFORM $MIRROR/minikube-$OS-$PLATFORM
}

dl linux amd64
dl darwin amd64
dl windows amd64
sha256sum $DIR/minikube-$VER-*

