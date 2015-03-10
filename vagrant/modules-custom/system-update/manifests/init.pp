class system-update {

  exec { 'system-update':
    command => 'apt-get update; apt-get dist-upgrade -y',
    logoutput => true,
  }

  $sysPackages = [ ]
  package { $sysPackages:
    ensure => "installed",
    require => Exec['system-update'],
    logoutput => true,
  }
}
