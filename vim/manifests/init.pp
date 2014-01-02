class vim {

  $solarized = 'yes'
  $vimbase = '/home/brasey/.vim'

  File {
      ensure  => file,
      owner   => 'brasey',
      group   => 'brasey',
      mode    => '0664',
  }

  package { 'vim-enhanced':
    ensure  => installed,
  }

  if $solarized == 'yes' {

    $gitbase = '/home/brasey/git'

    exec { 'clone_vim-colors-solarized_repo':
      command => '/usr/bin/git clone https://github.com/altercation/vim-colors-solarized.git',
      cwd     => $gitbase,
      user    => 'brasey',
      onlyif  => "/usr/bin/test ! -d ${gitbase}/vim-colors-solarized",
      require => Class[ 'gitrepos' ],
    }

    file { '/home/brasey/.vimrc':
      source  => 'file:///etc/puppet/modules/vim/files/.vimrc.solarized',
    }

    file { "${vimbase}/colors":
      ensure  => directory,
      mode    => '0775',
    }

    file { "${vimbase}/colors/solarized.vim":
      source  => "file://${gitbase}/vim-colors-solarized/colors/solarized.vim",
    }

  }
  else {

    file { '/home/brasey/.vimrc':
      source  => 'file:///etc/puppet/modules/vim/files/.vimrc',
    }

  }

}
