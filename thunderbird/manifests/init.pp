class thunderbird {

  package { 'thunderbird':
    ensure  => installed,
  }

  exec { 'restore_thunderbird':
    command => '/usr/bin/scp -rp pi@10.0.0.18:thunderbird/* /home/brasey/.thunderbird/',
    user    => 'brasey',
    require => Package[ 'thunderbird' ],
    onlyif  => '/usr/bin/grep -c gmail .thunderbird/*.default/prefs.js',
  }

}
