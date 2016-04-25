# == Class mosquitto::install
#
class mosquitto::install inherits mosquitto {

 
  file { $system_log_dir:
    ensure => directory,
    owner  => $mosquitto::user,
    group  => $mosquitto::group,
    mode   => '0755',
  }

  yumrepo { "home_oojah_mqtt":
    ensure => true,
    baseurl => "http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-6/home:oojah:mqtt.repo",
    descr => "CentOS Mosquitto repository",
    enabled => 1,
    gpgcheck => 1,
    gpgkey => "http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-6//repodata/repomd.xml.key"
  }

  package { 'mosquitto':
    ensure => $package_ensure,
    name   => $package_name,
    require => Yumrepo["home_oojah_mqtt"]
  }

# http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-6/home:oojah:mqtt.repo
# [home_oojah_mqtt]
# name=mqtt (CentOS_CentOS-6)
# type=rpm-md
# baseurl=http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-6/
# gpgcheck=1
# gpgkey=http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-6//repodata/repomd.xml.key
# enabled=1

  if $limits_manage == true {
    limits::fragment {
      "${user}/soft/nofile": value => $limits_nofile;
      "${user}/hard/nofile": value => $limits_nofile;
    }
  }
}
