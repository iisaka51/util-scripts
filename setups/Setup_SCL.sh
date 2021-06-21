#!/bin/bash

__AUTHOR__="Goichi Iisaka"
__VERSION__="1.0"
__DATE__="Jun 17 2021, Sunny day"

[ -f /etc/os-release ] || {
    echo "/etc/os-release: missing."
    echo "So, Not support this platform."
    exit 0
}

source /etc/os-release

case "${VERSION_ID}" in
7|8)	;;
*)	echo "Not support this version of platform." ; exit 1 ;;
esac

case "${ID}" in
centos)
    yum update -y
    yum groupinstall --downloadonly development
    yum groupinstall -y development
    yum install -y libcurl-devel cmake yum-utils
    yum install -y centos-release-scl
;;
redhat)
    subscription-manager repos --list | egrep rhscl || {
        echo "your subscription might not include Red Hat Software Collection (RHSCL)."
    cat <<'_EOF_'
Registering the System to RedHat Networks from command line.

RHNET_USERNAME=xxxx
RHNET_PASSWORD=yyyy
CREDENTIOALS="--username ${RHNET_USERNAME} --password ${RHNET_PASSWORD}"
subscription-manager register ${CREDENTIOALS} --auto-attach

After executing the above command, it will generate files as follows.

Client Key : /etc/pki/entitlement/<Numeric Number>-key.pem
Client Cert: /etc/pki/entitlement/<Numberic Number>.pem
Redhat CA Cert: /etc/rhsm/ca/redhat-uep.pem
Repositry: /etc/yum.repos.d/redhat.repo

_EOF_
        exit 0
    }

    yum update -y
    yum groupinstall --downloadonly development
    yum groupinstall -y development
    yum install -y libcurl-devel cmake yum-utils
    subscription-manager repos --enable rhel-server-rhscl-${VERSION_ID}-rpms
;;
*)
    echo "Not support this distribution."
    exit 1
;;
esac

[ -f /etc/yum.repos.d/elrepo.repo ] || {
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    yum install https://www.elrepo.org/elrepo-release-${VERSION_ID}.el${VERSION_ID}.elrepo.noarch.rpm
}

# See Also:
# https://developers.redhat.com/products/softwarecollections/hello-world#fndtn-python
# https://wiki.centos.org/FAQ/General#head-472ce8446ebcfc82ca1800f775ba0e629ac835c7
# https://www.softwarecollections.org/en/
# https://computing.help.inf.ed.ac.uk/scl
