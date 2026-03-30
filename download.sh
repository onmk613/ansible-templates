#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

docker_version="29.3.0"
compose_version="v5.1.1"
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
docker_download_url="https://download.docker.com/linux/static/stable/{{ host_arch }}/docker-{{ docker_version }}.tgz"
compose_download_url="https://github.com/docker/compose/releases/download/{{ docker_compose_version }}/docker-compose-linux-{{ host_arch }}"
download_docker_binary() {
    wget docker_download_url -O docker-{{ docker_version }}.tgz
    wget compose_download_url -O docker-compose-{{ host_arch }}-{{ compose_version }}
}

# node exporter download
node_exporter_download_url="https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-{{ host_arch_alias }}.tar.gz"
download_node_exporter() {
    wget node_exporter_download_url -O node_exporter-{{ node_exporter_version }}.linux-{{ host_arch_alias }}.tar.gz
}

download_docker_binary
download_node_exporter
