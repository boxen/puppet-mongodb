require "spec_helper"

describe "mongodb::service" do
  let(:facts) { default_test_facts }

  it do
    should contain_service("com.boxen.mongodb").with_ensure(:stopped)
    should contain_service("dev.mongodb").with_ensure(:running)
  end

  context "Ubuntu" do
    let(:facts) { default_test_facts.merge(:operatingsystem => "Ubuntu") }

    it do
      should_not contain_service("com.boxen.mongodb")
      should contain_service("mongodb").with_ensure(:running)
    end
  end
end

