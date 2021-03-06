require 'spec_helper'

describe 'xymon::client' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "xymon::client class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('xymon::params') }
          it { is_expected.to contain_class('xymon::client::install').that_comes_before('xymon::client::config') }
          it { is_expected.to contain_class('xymon::client::config') }
          it { is_expected.to contain_class('xymon::client::service').that_subscribes_to('xymon::client::config') }

          it { is_expected.to contain_service('xymon-client') }
          it { is_expected.to contain_package('xymon-client').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'xymon::client class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('xymon::client') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
