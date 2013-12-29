class bashrc {

  file { '/home/$id/.bashrc':
    ensure  => file,
    source  => 'file:///etc/puppet/modules/bashrc/files/.bashrc',
    owner   => $::id,
    group   => $::id,
    mode    => '0664',
    require => Class[ 'bashgitprompt' ],
  }

}
