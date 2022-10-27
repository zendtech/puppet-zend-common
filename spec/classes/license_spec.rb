# frozen_string_literal: true

require 'spec_helper'

describe 'zend_common::license' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      file_uri = 'puppet:///modules/test_module/licenses/test-license'
      let(:facts) { os_facts }
      let(:params) { { source: file_uri } }

      it { is_expected.to compile }
      it { is_expected.to contain_class('zend_common::license').with_source(file_uri) }

      describe 'creates license file' do
        it { is_expected.to contain_file('/opt/zend/zendphp/etc/license').with_source(file_uri) }
      end
    end
  end
end
