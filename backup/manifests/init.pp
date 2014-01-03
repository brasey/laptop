class backup {

  file { '/etc/cron.daily/backup.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'file:///etc/puppet/modules/backup/files/backup.sh',
  }

}
