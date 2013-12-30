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
    command     => '/bin/make',
    cwd         => '/usr/share/doc/git/contrib/credential/gnome-keyring',
    user        => 'root',
    environment => [ 'HOME=/home/brasey' ],
    onlyif      => '/usr/bin/test ! -f /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring',
    require     => Class[ 'gcc' ],
  }

  file { '/home/brasey/.gitconfig':
    ensure  => file,
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0664',
    source  => 'file:///etc/puppet/modules/gitrepos/files/.gitconfig',
  }

}
