class manheimpuppetrepos {

  $gitbase = "/home/${::id}/git"

  exec { 'manheim_puppet':
    command => '/usr/bin/git clone http://github.ove.local/PlatformServices/puppet.git',
    cwd     => $gitbase,
    user    => $::id,
    onlyif  => '/usr/bin/git remote -v | /usr/bin/grep -c fetch',
    require => Class[ 'gitrepos' ],
  }

  exec { 'manheim_hieradata':
    command => '/usr/bin/git clone http://github.ove.local/PlatformServices/hieradata.git',
    cwd     => $gitbase,
    user    => $::id,
    onlyif  => '/usr/bin/git remote -v | /usr/bin/grep -c fetch',
    require => Class[ 'gitrepos' ],
  }

  file { "${gitbase}/puppet/hooks/pre-commit":
    ensure  => file,
    source  => 'file:///etc/puppet/modules/manheimpuppetrepos/files/pre-commit',
    owner   => $::id,
    group   => $::id,
    mode    => '0775',
    require => Exec[ 'manheim_puppet' ],
  }

  file { "${gitbase}/hieradata/hooks/pre-commit":
    ensure  => file,
    source  => 'file:///etc/puppet/modules/manheimpuppetrepos/files/pre-commit',
    owner   => $::id,
    group   => $::id,
    mode    => '0775',
    require => Exec[ 'manheim_hieradata' ],
  }

  package { 'rubygem-puppet-lint':
    ensure  => installed,
  }

}
