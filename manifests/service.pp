# == Class mosquitto::service
#
class mosquitto::service inherits mosquitto {

  if ! ($service_ensure in [ 'absent', 'present' ]) {
    fail('service_ensure parameter must be absent or present')
  }

  if $service_manage == true {
    supervisor::service {
      $mosquitto::service_name:
        ensure                 => $mosquitto::service_ensure,
        enable                 => $mosquitto::service_enable,
        environment            => '', # this is required as otherwise the copilation fails
        command                => "${mosquitto::command} ${config}",
        config_file            => "${config}",
        # config_file            => undef,
        directory              => '/',
        user                   => $mosquitto::user,
        group                  => $mosquitto::group,
        autorestart            => $mosquitto::service_autorestart,
        startsecs              => $mosquitto::service_startsecs,
        stopwait               => $mosquitto::service_stopsecs,
        retries                => $mosquitto::service_retries,
        stdout_logfile_maxsize => $mosquitto::service_stdout_logfile_maxsize,
        stdout_logfile_keep    => $mosquitto::service_stdout_logfile_keep,
        stderr_logfile_maxsize => $mosquitto::service_stderr_logfile_maxsize,
        stderr_logfile_keep    => $mosquitto::service_stderr_logfile_keep,
        stopsignal             => 'INT',
        stopasgroup            => true,
        # require                => Class['::supervisor'],
        require                => [ Class['::supervisor'] ],
    }

    if $mosquitto::service_enable == true {
      exec { 'restart-mosquitto':
        command     => "supervisorctl restart ${mosquitto::service_name}",
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
