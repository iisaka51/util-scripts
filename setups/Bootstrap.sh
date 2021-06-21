#!/bin/bash

USERNAME=iisaka
CONDA_INSTALLDIR=/opt/anaconda3

cd /root

CONDA_BASEURL="https://repo.anaconda.com/miniconda"
CONDA_PKGNAME="Miniconda3-latest-Linux-x86_64.sh"

[ -f "${CONDA_PKGNAME}" ]  || {
  curl -sLO ${CONDA_BASEURL}/${CONDA_PKGNAME}
  bash ${CONDA_PKGNAME} -b -p ${CONDA_INSTALLDIR}
  curl -sLO https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  install -m 0755 jq-linux64 ${CONDA_INSTALLDIR}/bin/jq

  cat <<_EOF_ > ${CONDA_INSTALLDIR}/.condarc
custom_multichannels:
  openmyroad: [http://repobank.openmyroad.com/conda/pkgs/openmyroad/]
channels:
  - conda-forge
  - defaults
  - openmyroad
channels_alias: http://repobank.openmyroad.com/conda/pkgs
debug: false
ssl_verify: true
auto_activate_base: false
_EOF_

  ${CONDA_INSTALLDIR}/condabin/conda init bash
  exec $SHELL -l
}

grep -qs sudo /etc/group || groupadd sudo
grep -qs wheel /etc/sudoers && {
  # RHEL family
  sed -i  -e '/^%wheel\tALL=(ALL)\tALL/a %sudo\tALL=(ALL)\tALL' /etc/sudoers
}

[ -d /home/ubuntu/.ssh ] && {
  SRC_AUTHKEY_DIR=/home/ubuntu/.ssh
} || {
  SRC_AUTHKEY_DIR=/root/.ssh
}

[ -d /home/${USERNAME} ] || {
  # PW=$( python3 -c "import crypt; print(crypt.crypt('PASSWORD', 'SALT'))")
  PW=$( python3 -c "import crypt;import getpass as gw; pw1=gw.getpass(); pw2=gw.getpass('Password Again:'); pw1 == pw2 and print(crypt.crypt(pw1, 'Bootstrap'))")
  [ -z "${PW}" ] && { echo "Password mismatch. use default password."
      PW="inTpbzPWbfBGM"   # default encrypt password
  }
  useradd -m -d /home/${USERNAME} -p ${PW} -s /bin/bash ${USERNAME}
  usermod -a -G sudo ${USERNAME}

  mkdir -p /home/${USERNAME}/.ssh
  ssh-keygen -t rsa -f /home/${USERNAME}/.ssh/id_rsa -P ''
  cp /root/.ssh/authorized_keys  /home/${USERNAME}/.ssh
  chmod 0600  /home/${USERNAME}/.ssh/authorized_keys
  [ -d ${SRC_AUTHKEY_DIR} ] && {
    cat ${SRC_AUTHKEY_DIR}/authorized_keys \
        >> /home/${USERNAME}/.ssh/authorized_keys
    chown -R ${USERNAME}.${USERNAME} /home/${USERNAME}/.ssh
 }
}

