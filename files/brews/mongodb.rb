require "language/go"

class Mongodb < Formula
  homepage "https://www.mongodb.org/"

  depends_on "go" => :build
  stable do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.0.2.tar.gz"
    sha256 "010522203cdb9bbff52fbd9fe299b67686bb1256e2e55eb78abf35444f668399"
    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
        :tag => "r3.0.2",
        :revision => "a914adfcea7d76f07512415eec5cd8308e67318e"
    end
  end

  devel do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.1.1.tar.gz"
    sha256 "4f983680ff1cc61d021daed2e2d24c54c069d965ec47276678296240d59efb6f"
    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
        :tag => "r3.1.1",
        :revision => "6c959d3a8bd9704b5ee9e17e60a4236db6887dc3"
    end
  end

  bottle do
    cellar :any
    revision 2
    sha256 "25a97aa9a4b9d535120216b3960e0d34b75f86134c8f71127484140139f40fe7" => :yosemite
    sha256 "de5f3e5be894da1c8884ab0ebb827890d3bb4c228066cb6ec2f22d993869bf21" => :mavericks
    sha256 "6b565e5ba85d7deb8461dfcc34c4e5c07532a72f55d7c76af5b74fec84a153f1" => :mountain_lion
  end

  version '3.0.2-boxen1'

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"

  depends_on "boost" => :optional
  depends_on "go" => :build
  depends_on :macos => :snow_leopard
  depends_on "scons" => :build
  depends_on "openssl" => :optional

  def install
    ENV.libcxx if build.devel?

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      args = %W[]
      # Once https://github.com/mongodb/mongo-tools/issues/11 is fixed, also set CPATH.
      # For now, use default include path
      #
      if build.with? "openssl"
        args << "ssl"
        ENV["LIBRARY_PATH"] = "#{Formula["openssl"].opt_prefix}/lib"
        # ENV["CPATH"] = "#{Formula["openssl"].opt_prefix}/include"
      end
      system "./build.sh", *args
    end

    mkdir "src/mongo-tools"
    cp Dir["src/github.com/mongodb/mongo-tools/bin/*"], "src/mongo-tools/"

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --cc=#{ENV.cc}
      --cxx=#{ENV.cxx}
      --osx-version-min=#{MacOS.version}
    ]

    args << "--use-system-boost" if build.with? "boost"
    args << "--use-new-tools"

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
