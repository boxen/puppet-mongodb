# Internal: defaults
class mongodb::params {

  $ensure = present
  $host   = $::ipaddress_lo0
  $enable = true

  case $::operatingsystem {
    Darwin: {
      include boxen::config

      $configdir  = "${boxen::config::configdir}/mongodb"
      $datadir    = "${boxen::config::datadir}/mongodb"
      $executable = "${boxen::config::homebrewdir}/bin/mongod"
      $logdir     = "${boxen::config::logdir}/mongodb"
      $port       = 17017

      $package    = 'boxen/brews/mongodb'
      $version    = '2.4.4-boxen1'

      $service    = 'dev.mongodb'
    }

    Ubuntu: {
      $configdir  = '/etc/mongodb'
      $datadir    = '/data/db'
      $executable = undef # only used on Darwin
      $logdir     = '/var/log/mongodb'
      $port       = 27017

      $package    = 'mongodb'
      $version    = installed

      $service    = 'mongodb'
    }

    default: {
      fail('Unsupported OS!')
    }
  }
}
