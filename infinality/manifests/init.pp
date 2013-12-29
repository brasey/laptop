class infinality {

  exec { 'install_repo':
    command => '/usr/bin/rpm -Uvh http://www.infinality.net/fedora/linux/infinality-repo-1.0-1.noarch.rpm',
    onlyif  => '/usr/bin/grep -c enabled=1 /etc/yum.repos.d/infinality.repo',
    user    => 'root',
  }

  package { 'fontconfig-infinality':
    ensure  => installed,
    require => Exec[ 'install_repo' ],
  }

  package { 'freetype-infinality':
    ensure  => installed,
    require => Exec[ 'install_repo' ],
  }

}
