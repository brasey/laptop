class gedit {

  $gitbase = '/home/brasey/git'
  $geditbase = '/home/brasey/.local/share/gedit'

  Exec {
    user    => 'brasey',
  }

  File {
    ensure  => file,
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0664',
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
    source  => "file://${gitbase}/solarized-gedit/solarized-dark.xml",
    require => [ File[ "${geditbase}/styles" ], Exec[ 'clone_solarized-gedit_repo' ] ],
  }

  exec { 'configscheme':
    command => '/usr/bin/gsettings set org.gnome.gedit.preferences.editor scheme "\'solarizeddark\'"',
    onlyif  => '/usr/bin/test "$(/usr/bin/gsettings get org.gnome.gedit.preferences.editor scheme)" != "\'solarizeddark\'"',
    require => File[ "${geditbase}/styles/solarized-dark.xml" ],
  }

}
