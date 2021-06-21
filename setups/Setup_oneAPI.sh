#!/bin/bash

__AUTHOR__="Goichi Iisaka"
__VERSION__="1.0"
__DATE__="Jun 18 2021, cloudy day"

[ -f /etc/os-release ] || {
    echo "/etc/os-release: missing."
    echo "So, Not support this platform."
    exit 0
}

source /etc/os-release

case "${ID}" in
centos|redhat)

    cat <<_EOF_ > /etc/yum.repos.d/oneAPI.repo
[oneAPI]
name=Intel(R) oneAPI repository
baseurl=https://yum.repos.intel.com/oneapi
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
_EOF_

    rpm --import https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
    yum install --downloadonly intel-basekit intel-hpckit
    yum install -y intel-basekit intel-hpckit

    # for runtime libraries packages
    # yum install -y  intel-oneapi-runtime-libs


;;

ubuntu)
    curl -fsSL https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | apt-key add -
    echo "deb https://apt.repos.intel.com/oneapi all main" | \
        tee /etc/apt/sources.list.d/oneAPI.list
    apt update -y
    apt install intel-basekit intel-hpckit
    # for runtime libraries packages
    # apt install -y  intel-oneapi-runtime-libs
;;
*)
    echo "Not support this platform."
    exit 1
;;
esac

# See Also:
# https://software.intel.com/content/www/us/en/develop/tools/oneapi.html
