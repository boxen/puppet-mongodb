class mongodb::config {
  require boxen::config

  $configdir   = "${boxen::config::configdir}/mongodb"
  $configfile  = "${configdir}/mongod.conf"
  $datadir     = "${boxen::config::datadir}/mongodb"
  $executable  = "${boxen::config::homebrewdir}/bin/mongod"
  $logdir      = "${boxen::config::logdir}/mongodb"
  $logfile     = "${logdir}/mongodb.log"
  $consolefile = "${logdir}/console.log"
  $port        = 27017
}
