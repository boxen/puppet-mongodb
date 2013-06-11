require 'formula'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'
  url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.4.4.tgz'
  sha1 'd9abc5c3aa6e7c6c29bc7b4a15028091931ec7bb'
  version '2.4.4-boxen1'

  skip_clean :all

  def install
    prefix.install Dir['*']
  end
end
