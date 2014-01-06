class virtualization {

  package { 'kvm':
    ensure  => installed,
  }

  package { 'virt-manager':
    ensure  => installed,
  }

}
