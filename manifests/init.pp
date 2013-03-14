class mumble {
  package { 'mumble-server':
    ensure => installed,
  }

  service { 'mumble-server':
    ensure    => 'running',
    enable    => true,
    hasstatus => false,
    pattern   => '/usr/sbin/murmurd',
  }

  file{'/etc/mumble-server.ini':
    source => [ "puppet:///modules/site_mumble/${::fqdn}/mumble-server.ini",
                "puppet:///modules/site_mumble/mumble-server.ini",
                "puppet:///modules/mumble/mumble-server.ini" ],
    require => Package['mumble-server'],
    notify  => Service['mumble-server'],
    owner   => root,
    group   => mumble-server,
    mode    => 0640;
  }
}

class mumble::ssl inherits mumble {
  file { [ "/etc/mumble-server", "/etc/mumble-server/ssl", "/etc/mumble-server/ssl/certs", "/etc/mumble-server/ssl/private" ]:
    ensure  => directory,
    owner   => "root",
    group   => "mumble-server",
    mode    => 0750,
  }

  ssl::cert { "cert":
    owner   => 'mumble-server',
    group   => 'mumble-server',
    base    => '/etc/mumble-server/ssl',
    notify  => Service['mumble-server'],
    require => File['/etc/mumble-server/ssl/private'],
  }
}
