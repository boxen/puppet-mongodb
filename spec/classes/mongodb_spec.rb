require 'spec_helper'

describe 'mongodb' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen',
      :boxen_user => 'testuser',
    }
  end

  it do
    should include_class('mongodb::config')
    should include_class('homebrew')

    should contain_homebrew__formula('mongodb')

    should contain_package('boxen/brews/mongodb')

    should contain_service('dev.mongodb').with(:ensure => 'running')
  end
end