class backup {

  file { '/etc/cron.d/brasey_backup':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'file:///etc/puppet/modules/backup/files/brasey_backup',
  }

}
