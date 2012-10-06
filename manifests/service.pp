class mongodb::service {
  file { '/Library/LaunchDaemons/com.boxen.mongodb.plist':
    content => template('mongodb/com.boxen.mongodb.plist.erb'),
    group   => 'wheel',
    notify  => Service['com.boxen.mongodb'],
    owner   => 'root',
  }

  service { 'com.boxen.mongodb':
    ensure  => running,
    require => [
      Package['mongodb'],
      File['/Library/LaunchDaemons/com.boxen.mongodb.plist']
    ]
  }
}
