#!/bin/bash

SERVER='10.0.0.18'

if [ "$( ping -q -c 1 ${SERVER} | grep -c '1 received' )" -ne 0 ]; then
  # Backup GnuPG
  /usr/bin/gpg --export-ownertrust > ${HOME}/.gnupg/ownertrust.bak
  /usr/bin/rsync -ave ssh ${HOME}/.gnupg/secring.gpg pi@${SERVER}:gpg/
  /usr/bin/rsync -ave ssh ${HOME}/.gnupg/pubring.gpg pi@${SERVER}:gpg/
  /usr/bin/rsync -ave ssh ${HOME}/.gnupg/gpg.conf pi@${SERVER}:gpg/
  /usr/bin/rsync -ave ssh ${HOME}/.gnupg/ownertrust.bak pi@${SERVER}:gpg/
  /bin/rm -f ${HOME}/.gnupg/ownertrust.bak

  # Backup Thunderbird
  /usr/bin/rsync -ave ssh ${HOME}/.thunderbird/hkoss3qt.default/ pi@${SERVER}:thunderbird/

  # Backup Pidgin
  /usr/bin/rsync -ave ssh ${HOME}/.purple/ pi@${SERVER}:pidgin/

  # Backup keyrings
  /usr/bin/rsync -ave ssh ${HOME}/.local/share/keyrings/ pi@${SERVER}:keyrings/

  # Backup ssh keys
  /usr/bin/rsync -ave ssh ${HOME}/.ssh/ pi@${SERVER}:ssh/
else
  echo No
fi
