class mongodb::package {
  package { 'mongodb':
    notify => Service['dev.mongodb']
  }
}
