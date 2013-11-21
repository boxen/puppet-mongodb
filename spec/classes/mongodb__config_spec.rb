require "spec_helper"

describe "mongodb::config" do
  let(:facts) { default_test_facts }

  it do
    %w(config/mongodb data/mongodb log/mongodb).each do |d|
      should contain_file("/test/boxen/#{d}").with_ensure(:directory)
    end

    should contain_file("/test/boxen/config/mongodb/mongodb.conf")

    should include_class("boxen::config")

    should contain_file("/test/boxen/env.d/mongodb.sh").with_ensure(:absent)
    should contain_file("/Library/LaunchDaemons/dev.mongodb.plist")
    should contain_boxen__env_script("mongodb")
  end

  context "Ubuntu" do
    let(:facts) { default_test_facts.merge(:operatingsystem => "Ubuntu") }

    it do
      %w(/etc/mongodb /data/db /var/log/mongodb).each do |d|
        should contain_file(d).with_ensure(:directory)
      end

      should contain_file("/etc/mongodb/mongodb.conf")

      should_not include_class("boxen::config")

      should_not contain_file("/test/boxen/env.d/mongodb.sh").with_ensure(:absent)
      should_not contain_file("/Library/LaunchDaemons/dev.mongodb.plist")
      should_not contain_boxen__env_script("mongodb")
    end
  end
end
