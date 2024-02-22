#!/bin/bash

# Function to display script usage
usage() {
    echo "Usage: $0 -v <go_version> -a <architecture>"
    echo "Supported architectures: amd64, arm64, armv6l, armv7l, ppc64le, s390x, x86_64"
    exit 1
}

# Function to determine system architecture
get_architecture() {
    case $1 in
        amd64|x86_64)
            echo "amd64"
            ;;
        arm64)
            echo "arm64"
            ;;
        armv6l)
            echo "armv6l"
            ;;
        armv7l)
            echo "armv7l"
            ;;
        ppc64le)
            echo "ppc64le"
            ;;
        s390x)
            echo "s390x"
            ;;
        *)
            echo "Unsupported architecture: $1"
            exit 1
            ;;
    esac
}

# Parse command line options
while getopts ":v:a:" opt; do
    case $opt in
        v)
            GO_VERSION="$OPTARG"
            ;;
        a)
            ARCH="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Verify that both version and architecture are provided
if [ -z "$GO_VERSION" ] || [ -z "$ARCH" ]; then
    echo "Error: Go version and architecture must be provided."
    usage
fi

# Determine system architecture
ARCH=$(get_architecture "$ARCH")

# Specify the installation directory (change as needed)
INSTALL_DIR="/usr/local"

# Download and extract Go
wget https://golang.org/dl/go$GO_VERSION.linux-$ARCH.tar.gz
sudo tar -C $INSTALL_DIR -xzf go$GO_VERSION.linux-$ARCH.tar.gz
rm go$GO_VERSION.linux-$ARCH.tar.gz

# Set Go environment variables
echo 'export PATH=$PATH:'$INSTALL_DIR'/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc

echo 'export PATH=$PATH:'$INSTALL_DIR'/go/bin' >> ~/.zshrc
echo 'export GOPATH=$HOME/go' >> ~/.zshrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc

# Source the updated profile
source ~/.bashrc
source ~/.zshrc

# Verify installation
go version
