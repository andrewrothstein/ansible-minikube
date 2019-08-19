#!/usr/bin/env sh
VER=v1.3.1
DIR=~/Downloads
MIRROR=https://github.com/kubernetes/minikube/releases/download/$VER

dl_minikube()
{
    OS=$1
    PLATFORM=$2
    SUFFIX=$3
    OP=${OS}-${PLATFORM}${SUFFIX}
    URL=$MIRROR/minikube-${OP}.sha256
    printf "    # %s\n" $URL
    printf "    %s-%s: sha256:%s\n" $OS $PLATFORM `curl -sSL $URL | awk '{print $1}'`
}

dl_driver()
{
    DRIVER_NAME=$1
    FILE_NAME=docker-machine-driver-$DRIVER_NAME.sha256
    URL=$MIRROR/$FILE_NAME
    printf "minikube_driver_%s_checksums:\n" $DRIVER_NAME
    printf "  # %s\n" $URL
    printf "  %s: sha256:%s\n" $VER `curl -sSL $URL | awk '{print $1}'`
}

printf "  %s:\n" $VER
dl_minikube linux amd64
dl_minikube darwin amd64
dl_minikube windows amd64 .exe

dl_driver kvm2
dl_driver hyperkit
