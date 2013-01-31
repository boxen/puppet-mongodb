require 'formula'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'
  url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.2.2.tgz'
  sha1 'b3808eeb6fe481f87db176cd3ab31119f94f7cc1'
  version '2.2.2-boxen1'

  skip_clean :all

  def install
    prefix.install Dir['*']
  end
end
