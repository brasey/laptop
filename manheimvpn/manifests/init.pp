class manheimvpn {

  $base_dir = '/home/brasey/.juniper_networks'

  file { $base_dir:
    ensure  => directory,
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0770',
  }

  exec { 'restore_manheimvpn':
    command => "/usr/bin/rsync -ave ssh pi@10.0.0.18:manheimvpn/ ${base_dir}/",
    user    => 'brasey',
    require => File[ $base_dir ],
    onlyif  => "/usr/bin/test ! -f ${base_dir}/network_connect/ncsvc",
  }

  exec { 'chown_ncsvc':
    command => "/usr/bin/chown root:root ${base_dir}/network_connect/ncsvc",
    user    => 'root',
    require => Exec[ 'restore_manheimvpn' ],
    onlyif  => "/usr/bin/test \"$(/usr/bin/sudo /usr/bin/test -O ${base_dir}/network_connect/ncsvc)\" != 0",
  }

  file { '/usr/bin/jnc.pl':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    source  => 'file:///etc/puppet/modules/manheimvpn/files/jnc.pl',
  }

  package { [ 'xterm','ld-linux.so.2','libstdc++.so.6','libz.so.1','libXext.so.6','libXrender.so.1','libXtst.so.6' ]:
    ensure  => installed,
  }

}
