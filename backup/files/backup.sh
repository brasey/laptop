#!/bin/bash

SERVER='10.0.0.18'

if [ "$( ping -q -c 1 ${SERVER} | grep -c '1 received' )" -ne 0 ]; then

  /usr/bin/gpg --export-ownertrust > ${HOME}/.gnupg/ownertrust.bak
  /usr/bin/rsync -ave ssh ${HOME}/.gnupg/secring.gpg pi@${SERVER}:gpg/
  /usr/bin/rsync -ave ssh ${HOME}/.gnupg/pubring.gpg pi@${SERVER}:gpg/
  /usr/bin/rsync -ave ssh ${HOME}/.gnupg/gpg.conf pi@${SERVER}:gpg/
  /usr/bin/rsync -ave ssh ${HOME}/.gnupg/ownertrust.bak pi@${SERVER}:gpg/
  /bin/rm -f ${HOME}/.gnupg/ownertrust.bak

  /usr/bin/rsync -ave ssh ${HOME}/.thunderbird/hkoss3qt.default/ pi@${SERVER}:thunderbird/

  /usr/bin/rsync -ave ssh ${HOME}/.purple/ pi@${SERVER}:pidgin/

  /usr/bin/rsync -ave ssh ${HOME}/.local/share/keyrings/ pi@${SERVER}:keyrings/

  /usr/bin/rsync -ave ssh ${HOME}/.ssh/ pi@${SERVER}:ssh/

  /usr/bin/sudo /usr/bin/rsync -ave ssh /etc/sysconfig/network-scripts/*rasey* pi@${SERVER}:wifi/

  /usr/bin/sudo /usr/bin/rsync -ave ssh ${HOME}/.juniper_networks/ pi@${SERVER}:manheimvpn/

fi
