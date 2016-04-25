# == Class mosquitto::install
#
class mosquitto::install inherits mosquitto {

  package { 'mosquitto':
    ensure => $package_ensure,
    name   => $package_name,
  }

  file { $system_log_dir:
    ensure => directory,
    owner  => $mosquitto::user,
    group  => $mosquitto::group,
    mode   => '0755',
  }
}
