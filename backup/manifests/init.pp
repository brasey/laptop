class backup {

  File {
    ensure  => file,
    owner   => 'root',
    group   => 'root',
  }

  file { '/etc/cron.d/brasey_backup':
    mode    => '0644',
    source  => 'file:///etc/puppet/modules/backup/files/brasey_backup',
  }

  file { '/usr/bin/backup.sh':
    mode    => '0775',
    source  => 'file:///etc/puppet/modules/backup/files/backup.sh',
  }

}
