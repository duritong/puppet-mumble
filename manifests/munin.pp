# Plugins thanks to
# https://github.com/cmur2/munin-mumble/blob/master/mumble
class mumble::munin {
  package{'python-zeroc-ice':
    ensure => present,
  } -> munin::plugin::deploy{'mumble':
    ensure => 'present',
    source => 'mumble/munin/mumble',
    config => "env.icesecret ${mumble::icesecret}";
  }
}
