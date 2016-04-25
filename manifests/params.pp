# == Class mosquitto::params
#
class mosquitto::params {
  
  $base_dir = '/opt/mosquitto' # Base directory under which the Mosquitto RPM is installed
  $package_name = 'mosquitto'
  $package_manage = true
  $package_ensure = installed

  # $etc_directory = $::operatingsystem ? {
  #   /(?i:FreeBSD)/ => '/usr/local/etc',
  #  default        => '/etc' }
  $etc_directory = '/etc'

  $command             = "${base_dir}/bin/mosquitto.sh"

  $service_name        = 'mosquitto'
  $service_ensure      = running
  $service_autorestart = true
  $service_enable      = true
  $service_manage      = true
  $service_retries     = 999
  $service_startsecs   = 10
  $service_stopsecs    = 120


  $pid_file        = '/var/run/mosquitto.pid'
  $config          = "${etc_directory}/mosquitto/mosquitto.conf"
  $config_template = 'mosquitto/mosquitto.conf.erb'

  $bind_address = undef
  $port = 1883

  $log_dirs = ['/app/mosquitto/log']

  $gid                 = 53042
  $group               = 'mosquitto'

  $service_stderr_logfile_keep    = 10
  $service_stderr_logfile_maxsize = '20MB'
  $service_stdout_logfile_keep    = 5
  $service_stdout_logfile_maxsize = '20MB'

  $mosquitto_log4j_opts    = undef
  $mosquitto_opts          = undef

  $shell               = '/bin/bash'
  $system_log_dir      = '/var/log/mosquitto'
  $tmpfs_manage        = false
  $tmpfs_path          = '/tmpfs'
  $tmpfs_size          = '0k'

  $hostname            = undef
  $limits_manage       = false
  $limits_nofile       = 65536

  $uid                 = 53042
  $user                = 'mosquitto'
  $user_description    = 'Mosquitto system account'
  $user_ensure         = 'present'
  $user_home           = '/home/mosquitto'
  $user_manage         = true
  $user_managehome     = true

#  $base_dir            = '/opt/kafka' # Base directory under which the Kafka RPM is installed
#  $broker_id           = 0
#  $broker_port         = 9092
#  $command             = "${base_dir}/bin/kafka-run-class.sh kafka.Kafka"
#  $config              = "${base_dir}/config/server.properties"
#  $config_template     = 'kafka/server.properties.erb'
#  # The logs/ sub-dir is hardcoded in some Kafka scripts, and Kafka will also try to create it if it does not exist.
#  # The latter causes problems if Kafka files/dirs are owned by root:root but run as a different user.  For that reason
#  # we ensure that this directory exists and is writable by the designated Kafka user.  Our Puppet setup however does
#  # not make use of this sub-directory.
#  $embedded_log_dir    = "${base_dir}/logs"
#  $gc_log_file         = '/var/log/kafka/daemon-gc.log'
#  $gid                 = 53002
#  $group               = 'kafka'
#  $group_ensure        = 'present'
#  $hostname            = undef
#  $jmx_port            = 9999
#  $kafka_gc_log_opts   = '-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps'
#  $kafka_heap_opts     = '-Xmx256M'
#  $kafka_jmx_opts      = '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false'
#  $kafka_jvm_performance_opts = '-server -XX:+UseCompressedOops -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true'
#  $kafka_log4j_opts    = undef
#  $kafka_opts          = undef
#  $limits_manage       = false

#  $log_dirs            = ['/app/kafka/log']
#  $logging_config      = "${base_dir}/config/log4j.properties"
#  $logging_config_template        = 'kafka/log4j.properties.erb'
#  $package_ensure      = 'present'
#  $package_name        = 'kafka'
#  $service_autorestart = true
#  $service_enable      = true
#  $service_ensure      = 'present'
#  $service_manage      = true
#  $service_name        = 'kafka-broker'
#  $service_retries     = 999
#  $service_startsecs   = 10
#  $service_stderr_logfile_keep    = 10
#  $service_stderr_logfile_maxsize = '20MB'
#  $service_stdout_logfile_keep    = 5
#  $service_stdout_logfile_maxsize = '20MB'
#  $service_stopsecs    = 120
#  $shell               = '/bin/bash'
#  $system_log_dir      = '/var/log/kafka'
#  $tmpfs_manage        = false
#  $tmpfs_path          = '/tmpfs'
#  $tmpfs_size          = '0k'
#  $uid                 = 53002
#  $user                = 'kafka'
#  $user_description    = 'Kafka system account'
#  $user_ensure         = 'present'
#  $user_home           = '/home/kafka'
#  $user_manage         = true
#  $user_managehome     = true
#  $zookeeper_connect   = ['localhost:2181']

  case $::osfamily {
    'RedHat': {}

    default: {
      fail("The ${module_name} module is not supported on a ${::osfamily} based system.")
    }
  }
}
