require "formula"

class Mongodb < Formula
  homepage "https://www.mongodb.org/"

  stable do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.2.0.tar.gz"
    sha256 "c6dd1d1670b86cbf02a531ddf7a7cda8f138d8733acce33766f174bd1e5ab2ee"
  end

  version '3.2.0-boxen1'

  bottle do
    revision 2
    sha256 "0dde2411b7dc3ca802449ef276e3d5729aa617b4b7c1fe5712052c1d8f03f28e" => :el_capitan
    sha256 "a7b91ff62121d66ca77053c9d63234b35993761e620399bd245c8109b9c8f96d" => :yosemite
    sha256 "65d09370cff5f3c120ec91c8aef44f7bd42bd3184ca187e814c59a2750823558" => :mavericks
  end

  devel do
    url "http://downloads.mongodb.org/osx/mongodb-osx-x86_64-3.0.8-rc0.tgz"
    sha256 "7a54d48d07fed6216aba10b55c42c804c742790b59057a3d14455e9e99007516"
  end

  head "https://github.com/mongodb/mongo.git"

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"

  depends_on "scons" => :build
  depends_on "boost" => :optional
  depends_on "openssl" => :optional
  depends_on :macos => :mavericks

  def install
    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --osx-version-min=#{MacOS.version}
    ]

    args << "CC=#{ENV.cc}"
    args << "CXX=#{ENV.cxx}"

    args << "--use-sasl-client" if build.with? "sasl"
    args << "--use-system-boost" if build.with? "boost"
    args << "--use-new-tools"
    args << "--disable-warnings-as-errors" if MacOS.version >= :yosemite

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
