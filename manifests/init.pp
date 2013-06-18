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
) {
  package{'mumble-server':
    ensure => installed,
  } -> file{'/etc/mumble-server.ini':
    owner   => root,
    group   => mumble-server,
    mode    => '0640';
  } ~> service{'mumble-server':
    ensure    => 'running',
    enable    => true,
    hasstatus => false,
    pattern   => '/usr/sbin/murmurd',
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
    include mumble::munin
  }
}
