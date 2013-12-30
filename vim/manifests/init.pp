class vim {

  package { 'vim-enhanced':
    ensure  => installed,
  }

  file { '/home/brasey/.vimrc':
    ensure  => file,
    source  => 'file:///etc/puppet/modules/vim/files/.vimrc',
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0664',
  }

}
