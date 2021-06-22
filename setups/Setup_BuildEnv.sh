#!/bin/bash

[ -f /etc/os-release ] || {
   echo "/etc/os-release: missing."
   echo "Not support this distribution."
   exit 1
}

case "${ID}"
redhat|centos)
    sudo yum groupinstall -y development
    sudo yum install -y blas*.x86_64 lapack*.x86_64 fftw*.x86_64 \
            readline-devel readline
;;
ubuntu)
    sudo apt install -y \
        build-essential gfortran python-is-python3 python3-pip \
        pkg-config autoconf automake libtool \
        liblapack-dev libfftw3-dev \
            libreadline-dev 
;;
esac
