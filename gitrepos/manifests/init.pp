class gitrepos {

  $gitbase = "/home/${::id}/git"

  file { $gitbase:
    ensure  => directory,
    owner   => $::id,
    group   => $::id,
    mode    => '0775',
  }

  package { 'libgnome-keyring-devel':
    ensure  => installed,
  }

  exec { 'make_gnome_keyring_connector':
    command => '/bin/make',
    cwd     => '/usr/share/doc/git-1.8.3.1/contrib/credential/gnome-keyring',
    user    => 'root',
  }

  exec { 'enable_gnome_keyring_connector':
    command => '/usr/bin/git config --global credential.helper /usr/share/doc/git-1.8.3.1/contrib/credential/gnome-keyring/git-credential-gnome-keyring',
    user    => $::id,
    onlyif  => "/usr/bin/grep -c gnome-keyring /home/${::id}/.gitconfig",
  }

}
