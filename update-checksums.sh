#!/usr/bin/env sh
set -e
MIRROR=https://github.com/kubernetes/minikube/releases/download
OUT_DIR=${OUT_DIR:-defaults/main}
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

check_sum()
{
    local sum=$1
    local url=$2
    if ! printf '%s' "$sum" | grep -Eq '^[0-9a-f]{64}$'
    then
        echo "bad or missing checksum from $url: '$sum'" >&2
        exit 1
    fi
}

dl_minikube()
{
    local ver=$1
    local os=$2
    local arch=$3
    local suffix=${4:-}
    local platform=${os}-${arch}
    local qsuffix=${platform}${suffix}
    local url="$MIRROR/$ver/minikube-${qsuffix}.sha256"
    local sum
    if ! sum=$(curl -fsSL --proto '=https' --tlsv1.2 "$url" 2>/dev/null)
    then
        # linux-arm stopped being published after v1.37.0
        if [ "$platform" = "linux-arm" ]
        then
            echo "minikube-linux-arm is not published for $ver, skipping" >&2
            return 0
        fi
        echo "failed to fetch $url" >&2
        exit 1
    fi
    sum=$(printf '%s' "$sum" | awk '{print $1}')
    check_sum "$sum" "$url"
    printf "    # %s\n" "$url"
    printf "    %s: sha256:%s\n" "$platform" "$sum"
}

# the kvm2 and hyperkit drivers stopped being published after v1.37.0
dl_driver()
{
    local ver=$1
    local driver_name=$2
    local file_name=docker-machine-driver-$driver_name.sha256
    local url="$MIRROR/$ver/$file_name"
    local sum
    if ! sum=$(curl -fsSL --proto '=https' --tlsv1.2 "$url" 2>/dev/null)
    then
        echo "driver $driver_name is not published for $ver, skipping" >&2
        return 0
    fi
    sum=$(printf '%s' "$sum" | awk '{print $1}')
    check_sum "$sum" "$url"
    printf "  # %s\n" "$url"
    printf "  %s: sha256:%s\n" "$ver" "$sum"
}

dl_ver() {
    local ver=$1

    printf "  %s:\n" "$ver"
    dl_minikube "$ver" linux amd64
    dl_minikube "$ver" linux arm
    dl_minikube "$ver" linux arm64
    dl_minikube "$ver" linux ppc64le
    dl_minikube "$ver" linux s390x
    dl_minikube "$ver" darwin amd64
    dl_minikube "$ver" darwin arm64
    dl_minikube "$ver" windows amd64 .exe
}

# build every output first so a failure appends nothing to any file
build() {
    local ver=$1
    dl_ver "$ver" > "$TMP/minikube.yml"
    dl_driver "$ver" kvm2 > "$TMP/kvm2.yml"
    dl_driver "$ver" hyperkit > "$TMP/hyperkit.yml"
    cat "$TMP/minikube.yml" >> "$OUT_DIR/minikube_checksums.yml"
    cat "$TMP/kvm2.yml" >> "$OUT_DIR/minikube_driver_kvm2_checksums.yml"
    cat "$TMP/hyperkit.yml" >> "$OUT_DIR/minikube_driver_hyperkit_checksums.yml"
}

for v in "${@:-v1.39.0}"; do
    build "$v"
done
