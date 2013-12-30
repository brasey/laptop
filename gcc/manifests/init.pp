class gcc {

  package { 'gcc':
    ensure  => installed,
  }

  package { 'make':
    ensure  => installed,
  }

}
