class gitrepos {

  include gcc
  $gitbase = '/home/brasey/git'

  file { $gitbase:
    ensure  => directory,
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0775',
  }

  package { 'libgnome-keyring-devel':
    ensure  => installed,
  }

  exec { 'make_gnome_keyring_connector':
    command => '/bin/make',
    cwd     => '/usr/share/doc/git/contrib/credential/gnome-keyring',
    user    => 'root',
    require => Class[ 'gcc' ],
  }

  exec { 'enable_gnome_keyring_connector':
    command => '/usr/bin/git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring',
    user    => 'brasey',
    onlyif  => '/usr/bin/grep -c gnome-keyring /home/brasey/.gitconfig',
  }

}
