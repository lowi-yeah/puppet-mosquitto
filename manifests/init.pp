# == Class: mosquitto
#
# Deploys a Mosquitto MQTT broker.
#
# === Parameters
#
# TODO: Document each class parameter.
#

class mosquitto (

  $package_name    = $mosquitto::params::package_name,
  $package_manage  = $mosquitto::params::package_manage,
  $package_ensure  = $mosquitto::params::package_ensure,

  $etc_directory   = $mosquitto::params::etc_directory,
  $config          = $mosquitto::params::config,
  $config_template = $mosquitto::params::config_template,
  $pid_file        = $mosquitto::params::pid_file,

  $bind_address    = $mosquitto::params::bind_address,
  $port            = $mosquitto::params::port,

  $base_dir            = $mosquitto::params::base_dir,
  $command             = $mosquitto::params::command,
  
  $gid                 = $mosquitto::params::gid,
  $group               = $mosquitto::params::group,
  $group_ensure        = $mosquitto::params::group_ensure,
  $hostname            = $mosquitto::params::hostname,

  $mosquitto_opts      = $mosquitto::params::mosquitto_opts,
  $limits_manage       = hiera('mosquitto::limits_manage', $mosquitto::params::limits_manage),
  $limits_nofile       = $mosquitto::params::limits_nofile,
  $log_dirs            = $mosquitto::params::log_dirs,
  $logging_config      = $mosquitto::params::logging_config,
  $logging_config_template        = $mosquitto::params::logging_config_template,
  $service_autorestart = hiera('mosquitto::service_autorestart', $mosquitto::params::service_autorestart),
  $service_enable      = hiera('mosquitto::service_enable', $mosquitto::params::service_enable),
  $service_ensure      = $mosquitto::params::service_ensure,
  $service_manage      = hiera('mosquitto::service_manage', $mosquitto::params::service_manage),
  $service_name        = $mosquitto::params::service_name,
  $service_retries     = $mosquitto::params::service_retries,
  $service_startsecs   = $mosquitto::params::service_startsecs,
  $service_stderr_logfile_keep    = $mosquitto::params::service_stderr_logfile_keep,
  $service_stderr_logfile_maxsize = $mosquitto::params::service_stderr_logfile_maxsize,
  $service_stdout_logfile_keep    = $mosquitto::params::service_stdout_logfile_keep,
  $service_stdout_logfile_maxsize = $mosquitto::params::service_stdout_logfile_maxsize,
  $service_stopsecs    = $mosquitto::params::service_stopsecs,
  $shell               = $mosquitto::params::shell,
  $system_log_dir      = $mosquitto::params::system_log_dir,
  $tmpfs_manage        = $mosquitto::params::tmpfs_manage,
  $tmpfs_path          = $mosquitto::params::tmpfs_path,
  $tmpfs_size          = $mosquitto::params::tmpfs_size,
  $uid                 = $mosquitto::params::uid,
  $user                = $mosquitto::params::user,
  $user_description    = $mosquitto::params::user_description,
  $user_ensure         = $mosquitto::params::user_ensure,
  $user_home           = $mosquitto::params::user_home,
  $user_manage         = hiera('mosquitto::user_manage', $mosquitto::params::user_manage),
  $user_managehome     = hiera('mosquitto::user_managehome', $mosquitto::params::user_managehome),
) inherits mosquitto::params {

  validate_string($package_name)
  validate_string($package_ensure)
  validate_bool($package_manage)

  validate_string($service_name)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_bool($service_manage)

  validate_string($etc_directory)
  validate_absolute_path($etc_directory)

  validate_string($pid_file)
  validate_absolute_path($pid_file)

  validate_string($user)
  validate_string($bind_address)
  if !is_integer($port) { fail('The $port parameter must be an integer number') }

  validate_absolute_path($base_dir)
  validate_string($command)
  validate_absolute_path($config)
  validate_string($config_template)

  validate_string($group)
  validate_string($group_ensure)
  validate_string($hostname)

  validate_bool($limits_manage)
  if !is_integer($limits_nofile) { fail('The $limits_nofile parameter must be an integer number') }
  validate_array($log_dirs)
  validate_bool($service_autorestart)
  validate_bool($service_enable)
  if !is_integer($service_retries) { fail('The $service_retries parameter must be an integer number') }
  if !is_integer($service_startsecs) { fail('The $service_startsecs parameter must be an integer number') }
  if !is_integer($service_stderr_logfile_keep) {
    fail('The $service_stderr_logfile_keep parameter must be an integer number')
  }
  validate_string($service_stderr_logfile_maxsize)
  if !is_integer($service_stdout_logfile_keep) {
    fail('The $service_stdout_logfile_keep parameter must be an integer number')
  }
  validate_string($service_stdout_logfile_maxsize)
  if !is_integer($service_stopsecs) { fail('The $service_stopsecs parameter must be an integer number') }
  validate_absolute_path($shell)
  validate_absolute_path($system_log_dir)
  if !is_integer($uid) { fail('The $uid parameter must be an integer number') }
  validate_string($user)
  validate_string($user_description)
  validate_string($user_ensure)
  validate_absolute_path($user_home)
  validate_bool($user_manage)
  validate_bool($user_managehome)

  include '::mosquitto::users'
  include '::mosquitto::install'
  include '::mosquitto::config'
  include '::mosquitto::service'

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up. You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'mosquitto::begin': }
  anchor { 'mosquitto::end': }

  Anchor['mosquitto::begin']
  -> Class['::mosquitto::users']
  -> Class['::mosquitto::install']
  -> Class['::mosquitto::config']
  ~> Class['::mosquitto::service']
  -> Anchor['mosquitto::end']
}
