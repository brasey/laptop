class gpg {

  package { 'gnupg':
    ensure  => installed,
  }

  exec { 'fetch_files':
    command => '/usr/bin/rsync -ave ssh pi@10.0.0.18:gpg/ /home/brasey/.gnupg/',
    user    => 'brasey',
    require => Package[ 'gnupg' ],
    onlyif  => '/usr/bin/test "$(/usr/bin/gpg --list-secret-keys | /usr/bin/grep -c uid)" = 0',
  }

}
