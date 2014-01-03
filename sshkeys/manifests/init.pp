class sshkeys {

  exec { 'restore_sshkeys':
    command => '/usr/bin/rsync -ave ssh pi@10.0.0.18:ssh/ /home/brasey/.ssh',
    user    => 'brasey',
    onlyif  => '/usr/bin/test ! -f /home/brasey/.ssh/id_rsa_manheim',
  }

}
