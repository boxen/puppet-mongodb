# Public: Install MongoDB.
#
# Examples
#
#   include mongodb
class mongodb(
  $ensure     = $mongodb::params::ensure,

  $executable = $mongodb::params::executable,

  $configdir  = $mongodb::params::configdir,
  $datadir    = $mongodb::params::datadir,
  $logdir     = $mongodb::params::logdir,

  $host       = $mongodb::params::host,
  $port       = $mongodb::params::port,

  $package    = $mongodb::params::package,
  $version    = $mongodb::params::version,

  $service    = $mongodb::params::service,
  $enable     = $mongodb::params::enable,
) inherits mongodb::params {

  class { 'mongodb::config':
    ensure     => $ensure,

    executable => $executable,

    configdir  => $configdir,
    datadir    => $datadir,
    logdir     => $logdir,

    host       => $host,
    port       => $port,

    service    => $service,

    notify     => Service['mongodb'],
  }

  ~>
  class { 'mongodb::package':
    ensure  => $ensure,

    package => $package,
    version => $version,
  }

  ~>
  class { 'mongodb::service':
    ensure  => $ensure,

    service => $service,
    enable  => $enable,
  }
}
