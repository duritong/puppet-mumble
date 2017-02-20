# setup mumble
#
#  Parameters:
#
#    * config_content: get content for central config file from
#      this parameter. Useful for using templates
#    * config: options to set, see supported options in template
#    * manage_munin: deploy munin plugins?
#
class mumble(
  $config_content = false,
  $config         = {},
  $manage_munin   = false,
) {
  if $osfamily == 'RedHat' {
    $pkg_name = 'murmur'
    $service_name = 'murmur'
    $config_file  = '/etc/murmur/murmur.ini'
  } else {
    $pkg_name = 'mumble-server'
    $service_name = 'mumble-server'
    $config_file  = '/etc/mumble-server.ini'
  }
  package{$pkg_name:
    ensure => installed,
  } -> file{$config_file:
    owner   => root,
    group   => mumble-server,
    mode    => '0640';
  } ~> service{$service_name:
    ensure    => 'running',
    enable    => true,
  }

  if $config_content {
    File[$config_file]{
      content => $config_content,
    }
  } else {
    File[$config_file]{
      content => template('mumble/mumble-server.ini.erb'),
    }
  }

  if $manage_munin {
    include ::mumble::munin
  }
}
