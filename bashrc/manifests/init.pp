class bashrc {

  file { '/home/brasey/.bashrc':
    ensure  => file,
    source  => 'file:///etc/puppet/modules/bashrc/files/.bashrc',
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0644',
    require => Class[ 'bashgitprompt' ],
  }

}
