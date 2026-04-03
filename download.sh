#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

docker_version="29.3.0"
compose_version="v5.1.1"
buildx_version="v0.33.0"

node_exporter_version="1.10.2"

mkdir -p packages || true
cd packages

if [[ "$OSTYPE" == "darwin"* ]]; then
    TAR_CMD="gtar"
else
    TAR_CMD="tar"
fi


# Set architecture environment variables
set_arch_env() {
    host_arch="${host_arch:-x86_64}"
    case "$host_arch" in
        "x86_64")
            host_arch_alias="amd64"
            ;;
        "aarch64")
            host_arch_alias="arm64"
            ;;
        *)
            echo "Error: Unsupported architecture '$host_arch'. Only x86_64 and aarch64 are allowed."
            return 1
            ;;
    esac
}
set_arch_env || exit 1

# docker and compose download
docker_download_url="https://download.docker.com/linux/static/stable/${host_arch}/docker-${docker_version}.tgz"
compose_download_url="https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-linux-${host_arch}"
buildx_download_url="https://github.com/docker/buildx/releases/download/${buildx_version}/buildx-${buildx_version}.linux-${host_arch_alias}"
download_docker_binary() {
    mkdir -p docker/${host_arch}

    wget ${docker_download_url} -O docker-${docker_version}-${host_arch}.tgz
    $TAR_CMD -xf docker-${docker_version}-${host_arch}.tgz -C docker/${host_arch} --strip-components=1
    rm -f docker-${docker_version}-${host_arch}.tgz

    wget ${compose_download_url} -O docker/${host_arch}/docker-compose
    wget ${buildx_download_url} -O docker/${host_arch}/docker-buildx
}

# node exporter download
node_exporter_download_url="https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_version}/node_exporter-${node_exporter_version}.linux-${host_arch_alias}.tar.gz"
download_node_exporter() {
    mkdir -p node-exporter/${host_arch}
    wget ${node_exporter_download_url} -O node_exporter-${node_exporter_version}.linux-${host_arch_alias}.tar.gz
    $TAR_CMD -xf node_exporter-${node_exporter_version}.linux-${host_arch_alias}.tar.gz -C node-exporter/${host_arch} --strip-components=1 --wildcards '*/node_exporter'
    rm -f node_exporter-${node_exporter_version}.linux-${host_arch_alias}.tar.gz
}

download_docker_binary
download_node_exporter
