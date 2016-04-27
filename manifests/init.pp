class mosquitto (
  $bind_address        = $mosquitto::params::bind_address,
  $command             = $mosquitto::params::command,
  $config              = $mosquitto::params::config,
  $config_template     = $mosquitto::params::config_template,
  $gid                 = $mosquitto::params::gid,
  $group               = $mosquitto::params::group,
  $group_ensure        = $mosquitto::params::group_ensure,
  $package_ensure      = $mosquitto::params::package_ensure,
  $package_name        = $mosquitto::params::package_name,
  $port                = $mosquitto::params::port,
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
  $shell               = $mosquitto::params::shell,
  $uid                 = $mosquitto::params::uid,
  $user                = $mosquitto::params::user,
  $user_description    = $mosquitto::params::user_description,
  $user_ensure         = $mosquitto::params::user_ensure,
  $user_home           = $mosquitto::params::user_home,
  $user_manage         = hiera('mosquitto::user_manage', $mosquitto::params::user_manage),
  $user_managehome     = hiera('mosquitto::user_managehome', $mosquitto::params::user_managehome),
  $working_dir         = $mosquitto::params::working_dir,
) inherits mosquitto::params {

  validate_string($command)
  validate_absolute_path($config)
  validate_string($config_template)
  if !is_integer($gid) { fail('The $gid parameter must be an integer number') }
  validate_string($group)
  validate_string($group_ensure)
  validate_string($package_ensure)
  validate_string($package_name)
  if !is_integer($port) { fail('The $port parameter must be an integer number') }
  validate_bool($service_autorestart)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_string($service_name)
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
  validate_absolute_path($shell)
  if !is_integer($uid) { fail('The $uid parameter must be an integer number') }
  validate_string($user)
  validate_string($user_description)
  validate_string($user_ensure)
  validate_absolute_path($user_home)
  validate_bool($user_manage)
  validate_bool($user_managehome)
  validate_absolute_path($working_dir)

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
