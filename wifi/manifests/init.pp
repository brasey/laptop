class wifi {

  exec { 'restore_wifi':
    command => '/usr/bin/rsync -ave ssh pi@10.0.0.18:wifi/ /etc/sysconfig/network-scripts/',
    user    => 'root',
    onlyif  => '/usr/bin/test ! -f /etc/sysconfig/network-scripts/ifcfg-Auto_rasey',
  }

}
