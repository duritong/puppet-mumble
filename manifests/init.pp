# setup mumble
#
#  Parameters:
#
#    * config_content: get content for central config file from
#      this parameter. Useful for using templates
#    * config_source: Source path for your config
#    * manage_munin: deploy munin plugins?
#
class mumble(
  $config_content = false,
  $config_source  = [ "puppet:///modules/site_mumble/${::fqdn}/mumble-server.ini",
                      'puppet:///modules/site_mumble/mumble-server.ini',
                      'puppet:///modules/mumble/mumble-server.ini' ],
  $manage_munin   = false,
  $icesecret      = 'secureme',
) {
  if $osfamily == 'RedHat' {
    $pkg_name = 'murmur'
    $service_name = 'murmur'
  } else {
    $pkg_name = 'mumble-server'
    $service_name = 'mumble-server'
  }
  package{$pkg_name:
    ensure => installed,
  } -> file{'/etc/mumble-server.ini':
    owner   => root,
    group   => mumble-server,
    mode    => '0640';
  } ~> service{$service_name:
    ensure    => 'running',
    enable    => true,
  }

  if $config_content {
    File['/etc/mumble-server.ini']{
      content => $config_content,
    }
  } else {
    File['/etc/mumble-server.ini']{
      source => $config_source,
    }
  }

  if $manage_munin {
    include ::mumble::munin
  }
}
