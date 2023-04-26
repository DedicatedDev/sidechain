#!/bin/bash

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -c|--chain-id) chain_id="$2"; shift ;;
        -d|--denom) denom="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if genesis.json exists in the home directory
if [ ! -f "$HOME/.sidechaind/config/genesis.json" ]; then
    echo "genesis.json not found! Initializing node..."
    # Copy setup_node.sh from the build environment
    cp /go/src/github.com/sideprotocol/sidchain/scripts/setup_node.sh ./

    # Make the setup_node.sh script executable
    chmod +x ./setup_node.sh

    # Run the setup_node.sh script with the provided chain ID and denomination
    RUN ./setup_node.sh -c "${chain_id:-sidechain_7070-1}" -d "${denom:-aside}"

    echo "initialized!..."
fi

# Add debugging information to check if genesis.json file is created
if [ -f "$HOME/.sidechaind/config/genesis.json" ]; then
    echo "genesis.json file created successfully."
else
    echo "genesis.json file not created. Please check setup_node.sh script for issues."
fi

# Start sidechaind
exec sidechaind start
