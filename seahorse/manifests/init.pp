class seahorse {

  package { 'seahorse':
    ensure  => installed,
  }

  exec { 'restore_seahorse_backup':
    command => '/usr/bin/rsync -ave ssh pi@10.0.0.18:keyrings/ /home/brasey/.local/share/keyrings/',
    user    => 'brasey',
    require => Package[ 'seahorse' ],
    onlyif  => '/usr/bin/test ! -f /home/brasey/.local/share/keyrings/user.keystore.60AC2W',
  }

  file { '/tmp/configure_seahorse.sh':
    ensure  => file,
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0700',
    source  => 'file:///etc/puppet/modules/seahorse/files/configure_seahorse.sh',
  }

  exec { 'configseahorse':
    command => '/tmp/configure_seahorse.sh',
    user    => 'brasey',
    onlyif  => "/usr/bin/test '$(/usr/bin/gsettings get org.gnome.seahorse server-auto-publish)' = \"'true'\"",
  }

}
