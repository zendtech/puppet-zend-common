# frozen_string_literal: true

require 'spec_helper'

describe 'zend_common::license' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      file_uri = 'puppet:///modules/test_module/licenses/test-license'
      test_content = 'test-license-content'
      let(:facts) { os_facts }


      describe 'without params' do
        it { is_expected.to compile.and_raise_error(/.*/) }
      end

      describe 'with Puppet URL for source' do
        let(:params) { { source: file_uri } }
        it { is_expected.to compile }
        it { is_expected.to contain_class('zend_common::license').with_source(file_uri) }
        it { is_expected.to contain_file('/opt/zend/zendphp/etc/license').with_source(file_uri) }
      end
      
      describe 'with text for content' do
        let(:params) { { content: test_content } }
        it { is_expected.to compile }
        it { is_expected.to contain_class('zend_common::license').with_content(test_content) }
        it { is_expected.to contain_file('/opt/zend/zendphp/etc/license').with_content(test_content) }
      end
    end
  end
end
