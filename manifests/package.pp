class mongodb::package {
  package { 'mongodb':
    notify => Service['com.boxen.mongodb']
  }
}
