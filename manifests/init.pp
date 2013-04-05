# Public: Install MongoDB.
#
# Examples
#
#   include mongodb
class mongodb {
  include mongodb::config
  include homebrew

  file { [
    $mongodb::config::configdir,
    $mongodb::config::datadir,
    $mongodb::config::logdir
  ]:
    ensure  => directory,
  }

  file { $mongodb::config::configfile:
    content => template('mongodb/mongod.conf.erb'),
    notify  => Service['dev.mongodb']
  }


  file { "${boxen::config::envdir}/mongodb.sh":
    content => template('mongodb/env.sh.erb'),
    require => File[$boxen::config::envdir]
  }

  homebrew::formula { 'mongodb':
    before => Package['boxen/brews/mongodb']
  }

  package { 'boxen/brews/mongodb':
    ensure => '2.2.2-boxen1',
    notify => Service['dev.mongodb']
  }

  file { '/Library/LaunchDaemons/dev.mongodb.plist':
    content => template('mongodb/dev.mongodb.plist.erb'),
    group   => 'wheel',
    notify  => Service['dev.mongodb'],
    owner   => 'root',
  }

  service { 'dev.mongodb':
    ensure  => running,
  }

  service { 'com.boxen.mongodb': # replaced by dev.mongodb
    before => Service['dev.mongodb'],
    enable => false
  }
}
