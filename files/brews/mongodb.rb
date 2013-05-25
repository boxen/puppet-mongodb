require 'formula'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'
  url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.4.2.tgz'
  sha1 'e4e6a001a39b39a875bd24db986f3445400a8b64'
  version '2.4.2-boxen1'

  skip_clean :all

  def install
    prefix.install Dir['*']
  end
end
