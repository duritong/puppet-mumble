# ssl setup for mumble
class mumble::ssl inherits mumble {
  file {
    [ '/etc/mumble-server', '/etc/mumble-server/ssl',
      '/etc/mumble-server/ssl/certs',
      '/etc/mumble-server/ssl/private' ]:
    ensure  => directory,
    owner   => root,
    group   => 'mumble-server',
    mode    => '0750',
  }

  ssl::cert { 'cert':
    owner   => 'mumble-server',
    group   => 'mumble-server',
    base    => '/etc/mumble-server/ssl',
    notify  => Service['mumble-server'],
    require => File['/etc/mumble-server/ssl/private'],
  }
}
