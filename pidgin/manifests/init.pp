class pidgin {

  package { 'pidgin':
    ensure  => installed,
  }

  package { 'purple-sipe':
    ensure  => installed,
  }

  exec { 'restore_pidgin_configs':
    command => '/usr/bin/rsync -ave ssh pi@10.0.0.18:pidgin/ /home/brasey/.purple/',
    user    => 'brasey',
    require => Package[ 'pidgin' ],
    onlyif  => '/usr/bin/grep -c prpl-sipe .purple/accounts.xml',
  }

}
