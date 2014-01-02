class thunderbird {

  $profile_path = '/home/brasey/.thunderbird/hkoss3qt.default'

  package { 'thunderbird':
    ensure  => installed,
  }

  file { $profile_path:
    ensure  => directory,
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0700',
  }

  exec { 'restore_thunderbird':
    command => "/usr/bin/scp -rp pi@10.0.0.18:thunderbird/* ${profile_path}/",
    user    => 'brasey',
    require => File[ $profile_path ],
    onlyif  => "/usr/bin/grep -c gmail ${profile_path}/prefs.js",
  }

}
