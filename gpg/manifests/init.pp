class gpg {

  package { 'gnupg':
    ensure  => installed,
  }

  exec { 'fetch_files':
    command   => "/usr/bin/scp -rp pi@10.0.0.18:gpg/* /home/${::id}/.gnupg/",
    user      => $::id,
    requires  => Package[ 'gnupg' ],
    onlyif    => '/usr/bin/gpg --list-secret-keys | /usr/bin/grep -c uid',
  }

}
