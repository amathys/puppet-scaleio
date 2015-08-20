require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'scaleio::tb', :type => 'class' do
  let(:facts){
    {
      :interfaces => 'eth0',
      :architecture => 'x86_64',
      :operatingsystem => 'RedHat',
    }
  }

  let(:pre_condition){"Exec{ path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }"}

  describe 'with standard' do
    it { should compile.with_all_deps }
    it { should contain_class('scaleio') }
    it { should contain_package__verifiable('EMC-ScaleIO-tb').with_version('installed') }
    it { should_not contain_consul_kv('scaleio/sysname/cluster_setup/tiebreaker')}
  end


  context 'using consul' do
    let(:facts){
      {
        :interfaces => 'eth0',
        :ipaddress => '1.2.3.6',
        :architecture => 'x86_64',
        :operatingsystem => 'RedHat',
        :fqdn => 'consul.example.com'
      }
    }
    it { should contain_consul_kv('scaleio/sysname/cluster_setup/tiebreaker').with(
        :value   => 'ready',
        :require => ['Service[consul]', 'Package::Verifiable[EMC-ScaleIO-tb]']
      )}
  end
end

