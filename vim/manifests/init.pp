class vim {

  package { 'vim-enhanced':
    ensure  => installed,
  }

  file { "/home/${::id}/.vimrc":
    ensure  => file,
    source  => 'file:///etc/puppet/modules/vim/files/.vimrc',
    owner   => $::id,
    group   => $::id,
    mode    => '0664',
  }

}
