#!/bin/bash
usage() {
    echo "Usage: $0 -v <go_version>"
    exit 1
}

# Parse command line options
while getopts ":v:" opt; do
    case $opt in
        v)
            GO_VERSION="$OPTARG"
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

# Verify that the version is provided
if [ -z "$GO_VERSION" ]; then
    echo "Error: Go version not provided."
    usage
fi

# Specify the installation directory (change as needed)
INSTALL_DIR="/usr/local"

# Download and extract Go
wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz
sudo tar -C $INSTALL_DIR -xzf go$GO_VERSION.linux-amd64.tar.gz
rm go$GO_VERSION.linux-amd64.tar.gz

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
