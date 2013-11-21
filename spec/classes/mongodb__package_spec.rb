require "spec_helper"

describe "mongodb::package" do
  let(:facts) { default_test_facts }

  it do
    should contain_homebrew__formula("mongodb")
    should contain_package("boxen/brews/mongodb")
  end

  context "Ubuntu" do
    let(:facts) { default_test_facts.merge(:operatingsystem => "Ubuntu") }

    it do
      should_not contain_homebrew__formula("mongodb")
      should contain_package("mongodb")
    end
  end
end
