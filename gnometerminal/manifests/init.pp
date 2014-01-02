class gnometerminal {

  $solarized = 'yes'
  $profile_path = '/org/gnome/terminal/legacy/profiles:'

  $tango_profile_id = 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
  $solarized_profile_id = 'b1dcc9dd-5262-4d8d-a863-c897e6d979b8'

  File {
    ensure  => file,
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0700',
  }

  Exec {
    user    => 'brasey',
  }

  package { 'gnome-terminal':
    ensure  => installed,
  }

  file { '/tmp/tango_terminal_config.sh':
    source  => 'file:///etc/puppet/modules/gnometerminal/files/tango_terminal_config.sh',
  }

  file { '/tmp/solarized_terminal_config.sh':
    source  => 'file:///etc/puppet/modules/gnometerminal/files/solarized_terminal_config.sh',
  }

  exec { 'configtango':
    command => '/tmp/tango_terminal_config.sh',
    onlyif  => "/usr/bin/test \"$(/usr/bin/dconf read ${profile_path}/:${tango_profile_id}/visible-name)\" != \"'tango'\""
  }

  exec { 'configsolarized':
    command => '/tmp/solarized_terminal_config.sh',
    onlyif  => "/usr/bin/test \"$(/usr/bin/dconf read ${profile_path}/:${tango_profile_id}/visible-name)\" != \"'solarized'\""
  }

  exec { 'configlist':
    command => "/usr/bin/dconf write ${profile_path}/list \"[ \'${tango_profile_id}\', \'${solarized_profile_id}\' ]\"",
    onlyif  => "/usr/bin/test \"$(/usr/bin/dconf read ${profile_path}/list | grep -c b1dcc9dd)\" = 0",
  }

  if $solarized == 'yes' {
    exec { 'setdefault':
      command => "/usr/bin/dconf write ${profile_path}/default \"'${solarized_profile_id}'\"",
      onlyif  => "/usr/bin/test \"$(/usr/bin/dconf read ${profile_path}/default)\" != \"'solarized'\""
    }
  }
  else {
    exec { 'setdefault':
      command => "/usr/bin/dconf write ${profile_path}/default \"'${tango_profile_id}'\"",
      onlyif  => "/usr/bin/test \"$(/usr/bin/dconf read ${profile_path}/default)\" != \"'tango'\""
    }
  }

}
