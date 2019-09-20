#!/usr/bin/env sh
VER=${1:-v1.4.0}
DIR=~/Downloads
MIRROR=https://github.com/kubernetes/minikube/releases/download/$VER

dl_minikube()
{
    local os=$1
    local arch=$2
    local suffix=$3
    local platform=${os}-${arch}
    local qsuffix=${platform}${suffix}
    local url=$MIRROR/minikube-${qsuffix}.sha256
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform `curl -sSL $url | awk '{print $1}'`
}

dl_driver()
{
    local driver_name=$1
    local file_name=docker-machine-driver-$driver_name.sha256
    local url=$MIRROR/$file_name
    printf "minikube_driver_%s_checksums:\n" $driver_name
    printf "  # %s\n" $url
    printf "  %s: sha256:%s\n" $VER `curl -sSL $url | awk '{print $1}'`
}

printf "  %s:\n" $VER
dl_minikube linux amd64
dl_minikube darwin amd64
dl_minikube windows amd64 .exe

dl_driver kvm2
dl_driver hyperkit
