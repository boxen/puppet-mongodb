require "language/go"

class Mongodb < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.org/"

  stable do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.0.7.tar.gz"
    sha256 "2d25bae7c3bfb3c0e168fcad526dc212da72faaeae6d1573db631cacb172a7e7"

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
        :tag => "r3.0.7",
        :revision => "134c548992e8248c7a7c53777a652cbb2490ab6c"
    end
  end

  version '3.0.7-boxen1'

  bottle do
    revision 2
    sha256 "1a351bddefae96c4e17b6e679fa30f551ca8f7690898ab52911bbd61b8398e2d" => :el_capitan
    sha256 "9194f749a0f400d687e93ca41be83d0419c4d59a95d738ae0f99618aa91076ca" => :yosemite
    sha256 "7cf4a87166774c9276eb0e20b15219f05da236f21c2378823625a65c9983d1f1" => :mavericks
    sha256 "aef1a270e9946d298b076804161510f1acbcbc33fd35ff4558a4c06ce1206a13" => :mountain_lion
  end

  devel do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.1.9.tar.gz"
    sha256 "2caad29cfc94d029ba6af08f02158523863fb03f81094ff1a76789d70af31a86"

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
        :tag => "r3.1.9",
        :revision => "44b34407a8004b7801ae2bbdc664a8e54ea2a362"
    end
  end

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"

  needs :cxx11

  depends_on "boost" => :optional
  depends_on "go" => :build
  depends_on :macos => :mountain_lion
  depends_on "scons" => :build
  depends_on "openssl" => :optional

  def install
    ENV.cxx11 if MacOS.version < :mavericks
    ENV.libcxx if build.devel?

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      # https://github.com/Homebrew/homebrew/issues/40136
      inreplace "build.sh", '-ldflags "-X github.com/mongodb/mongo-tools/common/options.Gitspec `git rev-parse HEAD`"', ""

      args = %W[]

      if build.with? "openssl"
        args << "ssl"
        ENV["LIBRARY_PATH"] = "#{Formula["openssl"].opt_prefix}/lib"
        ENV["CPATH"] = "#{Formula["openssl"].opt_prefix}/include"
      end
      system "./build.sh", *args
    end

    mkdir "src/mongo-tools"
    cp Dir["src/github.com/mongodb/mongo-tools/bin/*"], "src/mongo-tools/"

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --osx-version-min=#{MacOS.version}
    ]

    if build.stable?
      args << "--cc=#{ENV.cc}"
      args << "--cxx=#{ENV.cxx}"
    end

    if build.devel?
      args << "CC=#{ENV.cc}"
      args << "CXX=#{ENV.cxx}"
    end

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
