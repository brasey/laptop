class syntastic {

  package { 'syntastic-sh':
    ensure  => installed,
  }

  package { 'syntastic-puppet':
    ensure  => installed,
  }

}
