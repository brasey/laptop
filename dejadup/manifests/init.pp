class dejadup {

  $dejadup_path = 'org.gnome.DejaDup'

  package { 'deja-dup':
    ensure  => installed,
  }

  file { '/tmp/configure_dejadup.sh':
    ensure  => file,
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0700',
    source  => 'file:///etc/puppet/modules/dejadup/files/configure_dejadup.sh',
  }

  exec { 'configdejadup':
    command => '/tmp/configure_dejadup.sh',
    onlyif  => "/usr/bin/test \"$(/usr/bin/gsettings get ${dejadup_path} backend)\" != \"'file'\""
  }

}
