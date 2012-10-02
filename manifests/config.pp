class mongodb::config {
  require github::config

  $configdir   = "${github::config::configdir}/mongodb"
  $configfile  = "${configdir}/mongod.conf"
  $datadir     = "${github::config::datadir}/mongodb"
  $executable  = "${github::config::homebrewdir}/bin/mongod"
  $logdir      = "${github::config::logdir}/mongodb"
  $logfile     = "${logdir}/mongodb.log"
  $consolefile = "${logdir}/console.log"
  $port        = 17017

  file { [$configdir, $datadir, $logdir]:
    ensure  => directory
  }

  file { $configfile:
    content => template('mongodb/mongod.conf.erb'),
    notify  => Service['com.setup.mongodb']
  }


  file { "${github::config::envdir}/mongodb.sh":
    content => template('mongodb/env.sh.erb'),
    require => File[$github::config::envdir]
  }
}
