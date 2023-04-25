FROM golang:1.19.4-bullseye AS build-env

WORKDIR /go/src/github.com/sideprotocol/sidchain

RUN apt-get update -y
RUN apt-get install git -y

COPY . .
RUN curl https://get.ignite.com/cli | bash
RUN make build

# Add these lines to run the ignite command to set up the genesis.json file
RUN ignite genesis init
RUN ignite genesis setconfig
RUN ignite genesis finalize

FROM golang:1.19.4-bullseye

RUN apt-get update -y
RUN apt-get install ca-certificates jq -y

WORKDIR /root

COPY --from=build-env /go/src/github.com/sideprotocol/sidchain/build/sidechaind /usr/bin/sidechaind

# Copy the generated genesis.json file to the final image
COPY --from=build-env /path/to/genesis.json /root/.sidechaind/config/genesis.json

EXPOSE 26656 26657 1317 9090 8545 8546

CMD ["sidechaind"]
