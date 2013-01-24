require 'formula'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'
  url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.2.2.tgz'
  md5 'f0c3b8039a8900c5d1b51343035ec7f5'
  version '2.2.2-boxen1'

  skip_clean :all

  def install
    prefix.install Dir['*']
  end
end
