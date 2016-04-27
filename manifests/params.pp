#
# == Class mosquitto::params
class mosquitto::params {
  
  $command             = 'mosquitto'
  $command_params      = '-c /etc/mosquitto/mosquitto.conf'
  $config              = '/etc/mosquitto/conf.d/mosquitto.conf'
  $config_template     = 'mosquitto/mosquitto.conf.erb'
  $gid                 = 53023
  $group               = 'mosquitto'
  $group_ensure        = 'present'
  $package_name        = 'mosquitto'
  $package_ensure      = 'present'
  # $bind_address        = undef
  $port                = 1883
  $service_autorestart = true
  $service_enable      = true
  $service_ensure      = 'present'
  $service_manage      = true
  $service_name        = 'mosquitto'
  $service_retries     = 999
  $service_startsecs   = 10
  $service_stderr_logfile_keep    = 10
  $service_stderr_logfile_maxsize = '20MB'
  $service_stdout_logfile_keep    = 5
  $service_stdout_logfile_maxsize = '20MB'
  $shell               = '/bin/bash'
  $uid                 = 53023
  $user                = 'mosquitto'
  $user_description    = 'Mosquitto system account'
  $user_ensure         = 'present'
  $user_home           = '/home/mosquitto'
  $user_manage         = true
  $user_managehome     = true
  $working_dir         = '/etc/mosquitto'
  case $::osfamily {
    'RedHat': {}

    default: {
      fail("The ${module_name} module is not supported on a ${::osfamily} based system.")
    }
  }
}
