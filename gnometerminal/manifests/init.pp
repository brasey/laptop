class gnometerminal {

  $profile_id = 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
  $profile_path = "/com/gnome/terminal/legacy/profiles:/:${profile_id}"

  package { 'gnome-terminal':
    ensure  => installed,
  }

  file { '/tmp/terminal_config.sh':
    ensure  => file,
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0700',
    creates => '/tmp/terminal_config.sh',
    source  => 'file:///etc/puppet/modules/gnometerminal/files/terminal_config.sh',
  }

  exec { 'configterminal':
    command => '/tmp/terminal_config.sh',
    user    => 'brasey',
    onlyif  => "test $(dconf read ${profile_path}/visible-name) != \"'brasey'\""
  }

}
