class mongodb::package {
  package { 'mongodb':
    notify => Service['com.setup.mongodb']
  }
}
