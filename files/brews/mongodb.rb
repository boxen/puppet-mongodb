require 'formula'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'
  url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.6.0.tgz'
  sha1 '35f8efe61d992f4b71c9205a9dbcab50e745c9a3'
  version '2.6.0-boxen1'

  skip_clean :all

  def install
    prefix.install Dir['*']
  end
end
