class bashgitprompt {

  exec { 'fetch_repo':
    command => '/usr/bin/git clone https://github.com/magicmonty/bash-git-prompt.git',
    cwd     => '/home/brasey/git',
    user    => 'brasey',
    require => Class[ 'gitrepos' ],
  }

}
