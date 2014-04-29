require 'formula'

class Mongodb < Formula
  homepage "http://www.mongodb.org/"
  url "http://downloads.mongodb.org/src/mongodb-src-r2.6.0.tar.gz"
  sha1 "35f8efe61d992f4b71c9205a9dbcab50e745c9a3"

  version '2.6.0-boxen1'

  bottle do
    sha1 "1c7b447ae2077b9efeaee2aa2c2474dc6b19ab6f" => :mavericks
    sha1 "0004e3bfb60db586f6ced02769ccd1cf325e0929" => :mountain_lion
    sha1 "7667f6cc36859fb9fced1885f382b76ae325583c" => :lion
  end

  head do
    url "https://github.com/mongodb/mongo.git"
  end

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"
  depends_on "boost" => :optional

  depends_on "scons" => :build
  depends_on "openssl" => :optional

  def install
    args = ["--prefix=#{prefix}", "-j#{ENV.make_jobs}"]

    cxx = ENV.cxx
    if ENV.compiler == :clang && MacOS.version >= :mavericks
      # when building on Mavericks with libc++
      # Use --osx-version-min=10.9 such that the compiler defaults to libc++.
      # Upstream issue discussing the default flags:
      # https://jira.mongodb.org/browse/SERVER-12682
      args << "--osx-version-min=10.9"
    end

    args << '--64' if MacOS.prefer_64_bit?
    args << "--cc=#{ENV.cc}"
    args << "--cxx=#{cxx}"

    # --full installs development headers and client library, not just binaries
    args << "--full"
    args << "--use-system-boost" if build.with? "boost"

    if build.with? 'openssl'
      args << '--ssl'
      args << "--extrapath=#{Formula["openssl"].opt_prefix}"
    end

    scons 'install', *args

    (buildpath+"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    (var+'mongodb').mkpath
    (var+'log/mongodb').mkpath
  end

  def mongodb_conf; <<-EOS.undent
    # Store data in #{var}/mongodb instead of the default /data/db
    dbpath = #{var}/mongodb

    # Append logs to #{var}/log/mongodb/mongo.log
    logpath = #{var}/log/mongodb/mongo.log
    logappend = true

    # Only accept local connections
    bind_ip = 127.0.0.1
    EOS
  end

  test do
    system "#{bin}/mongod", '--sysinfo'
  end
end
