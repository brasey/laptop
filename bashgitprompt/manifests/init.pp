class bashgitprompt {

  exec { 'fetch_repo':
    command => '/usr/bin/git clone https://github.com/magicmonty/bash-git-prompt.git',
    cwd     => "/home/${::id}/git",
    user    => $::id,
    require => Class[ 'gitrepos' ],
  }

}
