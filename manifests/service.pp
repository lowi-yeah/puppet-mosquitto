# == Class mosquitto::service
#
class mosquitto::service inherits mosquitto {

  if ! ($service_ensure in [ 'absent', 'present' ]) {
    fail('service_ensure parameter must be absent or present')
  }

  if $service_manage == true {
    supervisor::service {
      $service_name:
        ensure                 => $service_ensure,
        enable                 => $service_enable,
        environment            => '', # this is required as otherwise the copilation fails
        command                => "${command} ${command_params}",
        directory              => '/',
        user                   => $user,
        group                  => $group,
        autorestart            => $service_autorestart,
        startsecs              => $service_startsecs,
        retries                => $service_retries,
        stdout_logfile_maxsize => $service_stdout_logfile_maxsize,
        stdout_logfile_keep    => $service_stdout_logfile_keep,
        stderr_logfile_maxsize => $service_stderr_logfile_maxsize,
        stderr_logfile_keep    => $service_stderr_logfile_keep,
        require                => [ Class['mosquitto::config'], , Class['::supervisor'] ],
    }

    if $service_enable == true {
      exec { 'restart-mosquitto':
        command     => "supervisorctl restart ${service_name}",
        path        => ['/usr/bin', '/usr/sbin', '/sbin', '/bin'],
        user        => 'root',
        refreshonly => true,
        subscribe   => File[$config],
        onlyif      => 'which supervisorctl &>/dev/null',
        require     => Class['::supervisor'],
      }
    }
  }
}
