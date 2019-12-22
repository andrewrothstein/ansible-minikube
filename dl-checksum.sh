#!/usr/bin/env sh
DIR=~/Downloads
MIRROR=https://github.com/kubernetes/minikube/releases/download

dl_minikube()
{
    local ver=$1
    local os=$2
    local arch=$3
    local suffix=$4
    local platform=${os}-${arch}
    local qsuffix=${platform}${suffix}
    local url=$MIRROR/$ver/minikube-${qsuffix}.sha256
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform `curl -sSL $url | awk '{print $1}'`
}

dl_driver()
{
    local ver=$1
    local driver_name=$2
    local file_name=docker-machine-driver-$driver_name.sha256
    local url=$MIRROR/$ver/$file_name
    printf "minikube_driver_%s_checksums:\n" $driver_name
    printf "  # %s\n" $url
    printf "  %s: sha256:%s\n" $ver `curl -sSL $url | awk '{print $1}'`
}

dl_ver() {
    local ver=$1

    printf "  %s:\n" $ver
    dl_minikube $ver linux amd64
    dl_minikube $ver darwin amd64
    dl_minikube $ver windows amd64 .exe

    dl_driver $ver kvm2
    dl_driver $ver hyperkit
}

dl_ver ${1:-v1.6.2}
