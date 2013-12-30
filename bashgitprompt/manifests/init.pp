class bashgitprompt {

  $gitbase = '/home/brasey/git'

  exec { 'fetch_repo':
    command => '/usr/bin/git clone https://github.com/magicmonty/bash-git-prompt.git',
    cwd     => $gitbase,
    user    => 'brasey',
    onlyif  => "/usr/bin/test ! -d ${gitbase}/bash-git-prompt",
    require => Class[ 'gitrepos' ],
  }

}
