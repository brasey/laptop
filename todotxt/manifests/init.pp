class todotxt {

  $gitbase = '/home/brasey/git'

  exec { 'todo.txt_repo':
    command => '/usr/bin/git clone https://github.com/ginatrapani/todo.txt-cli.git',
    cwd     => $gitbase,
    user    => 'brasey',
    onlyif  => "/usr/bin/test ! -d ${gitbase}/todo.txt-cli",
    require => Class[ 'gitrepos' ],
  }

  file { '/home/brasey/bin/todo.sh':
    ensure  => link,
    target  => '/home/brasey/git/todo.txt-cli/todo.sh',
  }

}
