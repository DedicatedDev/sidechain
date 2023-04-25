name: Compile Side

on:
  pull_request:
  push:
    branches:
      - dev
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        arch: [amd64]
        targetos: [darwin, linux]
        include:
          - targetos: darwin
            arch: arm64
    name: side ${{ matrix.arch }} for ${{ matrix.targetos }}
    steps:
      - uses: actions/checkout@v2
      - name: Get git diff
        uses: technote-space/get-diff-action@v6.0.1
        with:
          PATTERNS: |
            **/**.wasm
            **/**!(test).go
            go.mod
            go.sum
            Makefile
      - uses: actions/setup-go@v2.1.4
        with:
          go-version: '^1.19'
        env:
          GOOS: ${{ matrix.targetos }}
          GOARCH: ${{ matrix.arch }}
        if: env.GIT_DIFF

      - name: Compile sidechain
        run: |
          go mod download
          cd cmd/sidechaind
          GOWRK=off go build .
        if: env.GIT_DIFF

      - name: Run generate-docs script
        run: |
          chmod +x ./scripts/generate-docs.sh
          ./scripts/generate-docs.sh
        if: env.GIT_DIFF

      - uses: actions/upload-artifact@v2
        with:
          name: sidechaind ${{ matrix.targetos }} ${{ matrix.arch }}
          path: cmd/sidechaind/sidechaind
        if: env.GIT_DIFF
