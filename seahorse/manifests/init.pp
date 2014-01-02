class seahorse {

  package { 'seahorse':
    ensure  => installed,
  }

  exec { 'restore_seahorse_backup':
    command => '/usr/bin/rsync -ave ssh pi@10.0.0.18:keyrings/ /home/brasey/.local/share/keyrings/',
    user    => 'brasey',
    require => Package[ 'seahorse' ],
    onlyif  => '/usr/bin/test ! -f /home/brasey/.local/share/keyrings/login.keyring',
  }

}
