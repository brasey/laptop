class googlechrome {

  file { '/etc/yum.repos.d/google-chrome.repo':
    ensure  => file,
    source => 'file:///etc/puppet/modules/googlechrome/files/google-chrome.repo',
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
  }

  file { '/tmp/linux_signing_key.pub':
    ensure  => file,
    source => 'file:///etc/puppet/modules/googlechrome/files/linux_signing_key.pub',
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    require => File[ '/etc/yum.repos.d/google-chrome.repo' ],
  }

  exec { 'import_signing_key':
    command => '/usr/bin/rpm --import /tmp/linux_signing_key.pub',
    onlyif  => '/usr/bin/rpm -qi gpg-pubkey-7fac5991-* | /usr/bin/grep -c Google',
    require => File[ '/tmp/linux_signing_key.pub' ],
  }

  package { 'google-chrome-stable':
    ensure  => installed,
    require => Exec[ 'import_signing_key' ],
  }

}
