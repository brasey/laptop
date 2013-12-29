class pidgin {

  package { 'pidgin':
    ensure  => installed,
  }

  package { 'purple-sipe':
    ensure  => installed,
  }

  exec { 'restore_configs':
    command   => "/usr/bin/scp -rp pi@10.0.0.18:pidgin/* /home/${::id}/.purple/",
    user      => $::id,
    requires  => Package[ 'pidgin' ],
    onlyif    => '/usr/bin/grep -c prpl-sipe .purple/accounts.xml',
  }

}
