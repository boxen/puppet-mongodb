class mongodb::config {
  require boxen::config

  $configdir   = "${boxen::config::configdir}/mongodb"
  $configfile  = "${configdir}/mongod.conf"
  $datadir     = "${boxen::config::datadir}/mongodb"
  $executable  = "${boxen::config::homebrewdir}/bin/mongod"
  $logdir      = "${boxen::config::logdir}/mongodb"
  $logfile     = "${logdir}/mongodb.log"
  $consolefile = "${logdir}/console.log"
  $port        = 17017

  file { [$configdir, $datadir, $logdir]:
    ensure  => directory
  }

  file { $configfile:
    content => template('mongodb/mongod.conf.erb'),
    notify  => Service['dev.mongodb']
  }


  file { "${boxen::config::envdir}/mongodb.sh":
    content => template('mongodb/env.sh.erb'),
    require => File[$boxen::config::envdir]
  }
}
