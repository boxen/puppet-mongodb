# Internal: Configuration files
class mongodb::config(
  $ensure     = $mongodb::params::ensure,

  $executable = $mongodb::params::executable,

  $configdir  = $mongodb::params::configdir,
  $datadir    = $mongodb::params::datadir,
  $logdir     = $mongodb::params::logdir,

  $host       = $mongodb::params::host,
  $port       = $mongodb::params::port,

  $service    = $mongodb::params::service,
) inherits mongodb::params {

  $dir_ensure = $ensure ? {
    present => directory,
    default => absent,
  }

  file {
    [
      $configdir,
      $datadir,
      $logdir,
    ]:
      ensure  => $dir_ensure;

    "${configdir}/mongodb.conf":
      ensure  => $ensure,
      content => template('mongodb/mongod.conf.erb') ;
  }

  if $::operatingsystem == 'Darwin' {
    include boxen::config

    file {
      "${boxen::config::envdir}/mongodb.sh":
        ensure  => absent ;

      "/Library/LaunchDaemons/${service}.plist":
        ensure  => $ensure,
        content => template('mongodb/dev.mongodb.plist.erb'),
        group   => 'wheel',
        owner   => 'root' ;
    }

    boxen::env_script { 'mongodb':
      ensure   => $ensure,
      content  => template('mongodb/env.sh.erb'),
      priority => 'lower',
    }
  }
}
