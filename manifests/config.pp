# == Class mosquitto::config
#
class mosquitto::config inherits mosquitto {

  file { $config:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($config_template),
    require => Class['mosquitto::install']
  }
}
