# Plugins thanks to https://github.com/munin-monitoring/contrib.git
class mumble::munin {
  package { 'python-zeroc-ice':
    ensure => present,
  }

  munin::plugin::deploy { 'mumble_users':
    source => "mumble/munin/mumble_users",
    ensure => "present",
  }

  munin::plugin::deploy { 'mumble_stats':
    source => "mumble/munin/mumble_stats",
    ensure => "present",
  }
}
