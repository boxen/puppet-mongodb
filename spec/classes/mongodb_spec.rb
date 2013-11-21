require "spec_helper"

describe "mongodb" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("mongodb::config")
    should contain_class("mongodb::package")
    should contain_class("mongodb::service")
  end
end
