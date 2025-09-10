#!/usr/bin/env bash

maindir="$(pwd)"
cd kernel
rm -rf KernelSU

# integrate kernelsu-SukiSu
curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" | bash -s nongki

