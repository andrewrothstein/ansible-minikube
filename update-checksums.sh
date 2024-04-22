#!/usr/bin/env sh
set -e
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
    printf "    %s: sha256:%s\n" $platform $(curl -sSL $url | awk '{print $1}')
}

dl_driver()
{
    local ver=$1
    local driver_name=$2
    local file_name=docker-machine-driver-$driver_name.sha256
    local url=$MIRROR/$ver/$file_name
    printf "  # %s\n" $url
    printf "  %s: sha256:%s\n" $ver $(curl -sSL $url | awk '{print $1}')
}

dl_ver() {
    local ver=$1

    printf "  %s:\n" $ver
    dl_minikube $ver linux amd64
    dl_minikube $ver linux arm
    dl_minikube $ver linux arm64
    dl_minikube $ver linux ppc64le
    dl_minikube $ver linux s390x
    dl_minikube $ver darwin amd64
    dl_minikube $ver darwin arm64
    dl_minikube $ver windows amd64 .exe

}

VER=${1:-v1.33.0}
dl_ver $VER >> defaults/main/minikube_checksums.yml
dl_driver $VER kvm2 >> defaults/main/minikube_driver_kvm2_checksums.yml
dl_driver $VER hyperkit >> defaults/main/minikube_driver_hyperkit_checksums.yml
