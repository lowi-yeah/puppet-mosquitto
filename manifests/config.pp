# == Class mosquitto::config
#
class mosquitto::config inherits mosquitto {

  file { $config:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($mosquitto::config_template),
  }

  # file { $logging_config:
  #   ensure  => file,
  #   owner   => root,
  #   group   => root,
  #   mode    => '0644',
  #   content => template($mosquitto::logging_config_template),
  # }

}
