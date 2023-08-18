name: Makefile CI

on:
  push:
    branches: [ "pmoineau.v0.3.0" ]
  pull_request:
    branches: [ "pmoineau.v0.3.0" ]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Make
      run: |
        ls -ltra
        cat /etc/os-release
        go version
        make
        ls -ltra
