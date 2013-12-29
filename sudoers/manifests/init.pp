class sudoers {

  file { '/etc/sudoers':
    ensure => 'present',
    source => "file:///etc/puppet/modules/sudoers/files/sudoers",
    owner  => 'root',
    group  => 'root',
    mode   => '0440',
  }

}
