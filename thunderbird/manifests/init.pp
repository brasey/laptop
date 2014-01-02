class thunderbird {

  $base_dir = '/home/brasey/.thunderbird'
  $profile = 'koss3qt.default'
  $profile_path = "${base_dir}/${profile}"

  package { 'thunderbird':
    ensure  => installed,
  }

  file { [ $base_dir, $profile_path ]:
    ensure  => directory,
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0700',
  }

  exec { 'restore_thunderbird':
    command => "/usr/bin/rsync -ave ssh pi@10.0.0.18:thunderbird/ ${profile_path}/",
    user    => 'brasey',
    require => File[ $profile_path ],
    onlyif  => "/usr/bin/test \"$(/usr/bin/grep -c gmail ${profile_path}/prefs.js)\" = 0",
  }

}
