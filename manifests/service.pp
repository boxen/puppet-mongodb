class mongodb::service {
  file { '/Library/LaunchDaemons/dev.mongodb.plist':
    content => template('mongodb/dev.mongodb.plist.erb'),
    group   => 'wheel',
    notify  => Service['dev.mongodb'],
    owner   => 'root',
  }

  service { 'dev.mongodb':
    ensure  => running,
    require => [
      Package['mongodb'],
      File['/Library/LaunchDaemons/dev.mongodb.plist']
    ]
  }

  service { 'com.boxen.mongodb': # replaced by dev.mongodb
    before => Service['dev.mongodb'],
    enable => false
  }
}
