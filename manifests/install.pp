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

  if $limits_manage == true {
    limits::fragment {
      "${user}/soft/nofile": value => $limits_nofile;
      "${user}/hard/nofile": value => $limits_nofile;
    }
  }
}
