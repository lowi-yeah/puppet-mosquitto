# == Class mosquitto::service
#
class mosquitto::service inherits mosquitto {

  if ! ($mosquitto::service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if $mosquitto::service_manage == true {

    supervisor::service { $mosquitto::service_name:
      ensure                 => $mosquitto::service_ensure,
      enable                 => $mosquitto::service_enable,
      command                => "${mosquitto::command} ${config}",
      directory              => '/',
      user                   => $mosquitto::user,
      group                  => $mosquitto::group,
      autorestart            => $mosquitto::service_autorestart,
      startsecs              => $mosquitto::service_startsecs,
      stopwait               => $mosquitto::service_stopsecs,
      retries                => $mosquitto::service_retries,
      stopsignal             => 'INT',
      stopasgroup            => true,
      require                => Class['::supervisor'],
    }

    if $mosquitto::service_enable == true {
      exec { 'restart-mosquitto-broker':
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
