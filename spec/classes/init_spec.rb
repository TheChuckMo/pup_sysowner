require 'spec_helper'
describe 'sysowner' do

  context 'with defaults for all parameters' do
    it { should contain_class('sysowner') }
  end
end
