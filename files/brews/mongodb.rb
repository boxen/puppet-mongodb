require "formula"

class Mongodb < Formula
  homepage "https://www.mongodb.org/"

  stable do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.0.2.tar.gz"
    sha1 "c24c4deb619e199d5c3688370b39ea6e4a4df204"
  end

  version '3.0.2-boxen1'

  bottle do
    revision 2
    sha1 "e6da509908fdacf9eb0f16e850e0516cd0898072" => :yosemite
    sha1 "5ab96fe864e725461eea856e138417994f50bb32" => :mavericks
    sha1 "193e639b7b79fbb18cb2e0a6bbabfbc9b8cbc042" => :mountain_lion
  end

  devel do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.1.1.tar.gz"
    sha1 "a0d9ae6baa6034d5373b3ffe082a8fea5c14774f"
  end

  # HEAD is currently failing. See https://jira.mongodb.org/browse/SERVER-15555
  head "https://github.com/mongodb/mongo.git"

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"

  depends_on "boost" => :optional
  depends_on :macos => :snow_leopard
  depends_on "scons" => :build
  depends_on "openssl" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --cc=#{ENV.cc}
      --cxx=#{ENV.cxx}
      --osx-version-min=#{MacOS.version}
    ]

    # --full installs development headers and client library, not just binaries
    # (only supported pre-2.7)
    args << "--use-system-boost" if build.with? "boost"
    args << "--64" if MacOS.prefer_64_bit?

    if build.with? "openssl"
      args << "--ssl" << "--extrapath=#{Formula["openssl"].opt_prefix}"
    end

    scons "install", *args

    (buildpath+"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    (var+"mongodb").mkpath
    (var+"log/mongodb").mkpath
  end

  def mongodb_conf; <<-EOS.undent
    systemLog:
      destination: file
      path: #{var}/log/mongodb/mongo.log
      logAppend: true
    storage:
      dbPath: #{var}/mongodb
    net:
      bindIp: 127.0.0.1
    EOS
  end

  test do
    system "#{bin}/mongod", "--sysinfo"
  end
end
