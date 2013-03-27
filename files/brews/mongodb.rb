require 'formula'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'
  url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.4.1.tgz'
  sha1 'd11220cdaf5e8edb88b7b4cc0828ffa6149dd7b5'
  version '2.4.1-boxen1'

  skip_clean :all

  def install
    prefix.install Dir['*']
  end
end
