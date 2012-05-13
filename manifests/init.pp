class mumble {
  package { 'mumble-server':
    ensure => installed,
  }

  service { 'mumble-server':
    ensure => 'running',
    enable => true,
  }

  file{'/etc/mumble-server.ini':
    source => [ "puppet:///modules/site-mumble/${fqdn}/mumble-server.ini",
                "puppet:///modules/site-mumble/mumble-server.ini",
                "puppet:///modules/mumble/mumble-server.ini" ],
    require => Package['mumble-server'],
    notify  => Service['mumble-server'],
    owner   => root,
    group   => mumble-server,
    mode    => 0640;
  }
}
