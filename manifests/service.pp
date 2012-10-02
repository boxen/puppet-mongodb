class mongodb::service {
  file { '/Library/LaunchDaemons/com.setup.mongodb.plist':
    content => template('mongodb/com.setup.mongodb.plist.erb'),
    group   => 'wheel',
    notify  => Service['com.setup.mongodb'],
    owner   => 'root',
  }

  service { 'com.setup.mongodb':
    ensure  => running,
    require => [
      Package['mongodb'],
      File['/Library/LaunchDaemons/com.setup.mongodb.plist']
    ]
  }
}
