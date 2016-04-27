# == Class mosquitto::install
#
class mosquitto::install inherits mosquitto {

  yumrepo { 'home_oojah_mqtt':
    ensure   => 'present',
    baseurl  => 'http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-6/home:oojah:mqtt.repo',
    descr    => 'CentOS Mosquitto repository',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => 'http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-6//repodata/repomd.xml.key'
  }

  package { 'mosquitto':
    ensure  => $package_ensure,
    name    => $package_name,
    require => Yumrepo['home_oojah_mqtt']
  }

  # This exec ensures we create intermediate directories for $working_dir as required
  exec { 'create-mosquitto-working-directory':
    command => "mkdir -p ${working_dir}",
    path    => ['/bin', '/sbin'],
    require => Package['mosquitto'],
  }
  ->
  file { $working_dir:
    ensure       => directory,
    owner        => $user,
    group        => $group,
    mode         => '0750',
    recurse      => true,
    recurselimit => 0,
  }

  
}
