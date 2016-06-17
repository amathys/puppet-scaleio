require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'scaleio::tb', :type => 'class' do
  # facts definition
  let(:facts_default) do
    {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemmajrelease => '7',
        :concat_basedir => '/var/lib/puppet/concat',
        :is_virtual => false,
        :ipaddress => '10.0.0.4',
        :interfaces => 'eth0',
        :ipaddress_eth0 => '10.0.0.4',
        :fqdn => 'node1.example.com',
        :kernel => 'linux',
        :architecture => 'x86_64',
    }
  end
  let(:facts) { facts_default }

  # pre_condition definition
  let(:pre_condition) do
    [
        "Exec{ path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }",
        "include scaleio",
    ]
  end

  describe 'with standard' do
    it { should compile.with_all_deps }
    it { should contain_class('scaleio::mdm::installation') }
    it { should_not contain_consul_kv('scaleio/sysname/cluster_setup/tiebreaker')}
  end


  describe 'using consul' do
    let(:facts) { facts_default.merge({:fqdn => 'use_consul.example.com'}) }

    it { should contain_consul_kv('scaleio/sysname/cluster_setup/tiebreaker').with(
        :value   => 'ready',
        :require => ['Service[consul]', 'Package::Verifiable[EMC-ScaleIO-mdm]']
      )}
  end

end

