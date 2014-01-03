class manheimpuppetrepos {

  $gitbase = '/home/brasey/git'

  exec { 'manheim_puppet':
    command => '/usr/bin/git clone http://github.ove.local/PlatformServices/puppet.git',
    cwd     => $gitbase,
    user    => 'brasey',
    onlyif  => "/usr/bin/test ! -d ${gitbase}/puppet",
    require => Class[ 'gitrepos' ],
  }

  exec { 'manheim_hieradata':
    command => '/usr/bin/git clone http://github.ove.local/PlatformServices/hieradata.git',
    cwd     => $gitbase,
    user    => 'brasey',
    onlyif  => "/usr/bin/test ! -d ${gitbase}/puppet",
    require => Class[ 'gitrepos' ],
  }

  exec { 'clone_puppet-git-hooks':
    command => '/usr/bin/git clone https://github.com/drwahl/puppet-git-hooks.git',
    cwd     => $gitbase,
    user    => 'brasey',
    onlyif  => "/usr/bin/test ! -d ${gitbase}/puppet-git-hooks",
    require => Class[ 'gitrepos' ],
  }

  file { "${gitbase}/puppet/hooks/pre-commit":
    ensure  => file,
    source  => "file://${gitbase}/puppet-git-hooks/pre-commit",
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0775',
    require => [ Exec[ 'manheim_puppet' ], Exec[ 'clone_puppet-git-hooks' ] ],
  }

  file { "${gitbase}/hieradata/hooks/pre-commit":
    ensure  => file,
    source  => "file://${gitbase}/puppet-git-hooks/pre-commit",
    owner   => 'brasey',
    group   => 'brasey',
    mode    => '0775',
    require => [ Exec[ 'manheim_hieradata' ], Exec[ 'clone_puppet-git-hooks' ] ],
  }

  package { 'rubygem-puppet-lint':
    ensure  => installed,
  }

}
