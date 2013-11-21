# Internal: install mongodb package
class mongodb::package(
  $ensure  = $mongodb::params::ensure,

  $package = $mongodb::params::package,
  $version = $mongodb::params::version,
) inherits mongodb::params {

  $package_ensure = $ensure ? {
    present => $version,
    default => absent,
  }

  if $::operatingsystem == 'Darwin' {
    homebrew::formula { 'mongodb': }
  }

  package { $package:
    ensure => $package_ensure,
  }

}
