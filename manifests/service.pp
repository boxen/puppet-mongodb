# Internal: Manage mongodb service
class mongodb::service(
  $ensure  = $mongodb::params::ensure,

  $service = $mongodb::params::service,
  $enable  = $mongodb::params::enable,
) inherits mongodb::params {

  $svc_ensure = $ensure ? {
    present => running,
    default => absent,
  }

  if $::operatingsystem == 'Darwin' {
    service { 'com.boxen.mongodb': # replaced by dev.mongodb
      ensure => stopped,
      before => Service[$service],
      enable => false,
    }
  }

  service { $service:
    ensure => $svc_ensure,
    enable => $enable,
    alias  => 'mongodb',
  }

}
