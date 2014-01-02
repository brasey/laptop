class gedit {

  $gitbase = '/home/brasey/git'
  $geditbase = '/home/brasey/.local/share/gedit'

  File {
    owner   => 'brasey',
    group   => 'brasey',
  }

  package { 'gedit':
    ensure  => installed,
  }

  exec { 'clone_solarized-gedit_repo':
    command => '/usr/bin/git clone https://github.com/mattcan/solarized-gedit.git',
    cwd     => $gitbase,
    user    => 'brasey',
    onlyif  => "/usr/bin/test ! -d ${gitbase}/solarized-gedit",
    require => Class[ 'gitrepos' ],
  }

  file { [ $geditbase, "${geditbase}/styles" ]:
    ensure  => directory,
    mode    => '0775',
  }

  file { "${geditbase}/styles/solarized-dark.xml":
    ensure  => file,
    mode    => '0664',
    source  => "file://${gitbase}/solarized-gedit/solarized-dark.xml",
    require => [ File[ "${geditbase}/styles" ], Exec[ 'clone_solarized-gedit_repo' ] ],
  }

}
