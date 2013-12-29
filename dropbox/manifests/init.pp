class dropbox {

  file { '/etc/yum.repos.d/dropbox.repo':
    ensure  => file,
    source  => 'file:///etc/puppet/modules/dropbox/files/dropbox.repo',
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
  }

  package { 'nautilus-dropbox':
    ensure  => installed,
  }

}
