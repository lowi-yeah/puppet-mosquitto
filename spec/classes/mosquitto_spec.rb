require 'spec_helper'

describe 'mosquitto' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      ['RedHat', 'CentOS', 'Amazon', 'Fedora'].each do |operatingsystem|
        let(:facts) {{
          :osfamily        => osfamily,
          :operatingsystem => operatingsystem,
        }}

        default_broker_configuration_file  = '/etc/mosquitto/mosquitto.conf'

        context "with explicit data (no Hiera)" do

          describe "mosquitto with default settings on #{osfamily}" do
            let(:params) {{ }}
            # We must mock $::operatingsystem because otherwise this test will
            # fail when you run the tests on e.g. Mac OS X.
            it { should compile.with_all_deps }

            it { should contain_class('mosquitto::params') }
            it { should contain_class('mosquitto') }
            it { should contain_class('mosquitto::users').that_comes_before('mosquitto::install') }
            it { should contain_class('mosquitto::install').that_comes_before('mosquitto::config') }
            it { should contain_class('mosquitto::config') }
            it { should contain_class('mosquitto::service').that_subscribes_to('mosquitto::config') }

            it { should contain_package('mosquitto').with_ensure('present') }

            it { should contain_group('mosquitto').with({
              'ensure'     => 'present',
              'gid'        => 53042
            })}

            it { should contain_user('mosquitto').with({
              'ensure'     => 'present',
              'home'       => '/home/mosquitto',
              'shell'      => '/bin/bash',
              'uid'        => 53042,
              'comment'    => 'Mosquitto system account',
              'gid'        => 'mosquitto',
              'managehome' => true
            })}

            #it { should contain_file('/opt/mosquitto/logs').with({
            #  'ensure' => 'directory',
            #  'owner'  => 'mosquitto',
            #  'group'  => 'mosquitto',
            #  'mode'   => '0755',
            #})}

            it { should contain_file('/var/log/mosquitto').with({
              'ensure' => 'directory',
              'owner'  => 'mosquitto',
              'group'  => 'mosquitto',
              'mode'   => '0755',
            })}

            it { should contain_file(default_broker_configuration_file).with({
                'ensure' => 'file',
                'owner'  => 'root',
                'group'  => 'root',
                'mode'   => '0644',
              }).
              with_content(/\sport\s1883\s/)
            }


            it { should_not contain_file('/tmpfs') }
            it { should_not contain_mount('/tmpfs') }

            it { should contain_supervisor__service('mosquitto').with({
              'ensure'      => 'present',
              'enable'      => true,
              'command'     => '/opt/mosquitto/bin/mosquitto.sh /etc/mosquitto/mosquitto.conf',
              'user'        => 'mosquitto',
              'group'       => 'mosquitto',
              'autorestart' => true,
              'startsecs'   => 10,
              'retries'     => 999,
              'stopsignal'  => 'INT',
              'stopasgroup' => true,
              'stopwait'    => 120,
              'stdout_logfile_maxsize' => '20MB',
              'stdout_logfile_keep'    => 5,
              'stderr_logfile_maxsize' => '20MB',
              'stderr_logfile_keep'    => 10,
            })}
          end

          describe "mosquitto with limits_manage enabled on #{osfamily}" do
            let(:params) {{
              :limits_manage => true,
            }}
            it { should contain_limits__fragment('mosquitto/soft/nofile').with_value(65536) }
            it { should contain_limits__fragment('mosquitto/hard/nofile').with_value(65536) }
          end

          describe "mosquitto with disabled user management on #{osfamily}" do
            let(:params) {{
              :user_manage  => false,
            }}
            it { should_not contain_group('mosquitto') }
            it { should_not contain_user('mosquitto') }
          end

          describe "mosquitto with custom user and group on #{osfamily}" do
            let(:params) {{
              :user_manage      => true,
              :gid              => 456,
              :group            => 'mosquittogroup',
              :uid              => 123,
              :user             => 'mosquittouser',
              :user_description => 'Mosquitto MQTT broker user',
              :user_home        => '/home/mosquittouser',
            }}

            it { should_not contain_group('mosquitto') }
            it { should_not contain_user('mosquitto') }

            it { should contain_user('mosquittouser').with({
              'ensure'     => 'present',
              'home'       => '/home/mosquittouser',
              'shell'      => '/bin/bash',
              'uid'        => 123,
              'comment'    => 'Mosquitto MQTT broker user',
              'gid'        => 'mosquittogroup',
              'managehome' => true,
            })}

            it { should contain_group('mosquittogroup').with({
              'ensure'     => 'present',
              'gid'        => 456,
            })}
          end

          describe "mosquitto with a custom port on #{osfamily}" do
            let(:params) {{
              :port => 9093,
            }}
            it { should contain_file(default_broker_configuration_file).with_content(/\sport\s9093\s/) }
          end
        end

      end
    end
  end

  # context 'unsupported operating system' do
  #   describe 'kafka without any parameters on Debian' do
  #     let(:facts) {{
  #       :osfamily => 'Debian',
  #     }}

  #     it { expect { should contain_class('kafka') }.to raise_error(Puppet::Error,
  #       /The kafka module is not supported on a Debian based system./) }
  #   end
  # end
end
