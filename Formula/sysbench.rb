class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.17.tar.gz"
  sha256 "9bcad62eaf473510f5184f33cc41f1e07c2640c8810ae9eebe25ba27ba04df5d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    sha256 "064afff9de05baa1de8eea0fb9d4c94fb247c87364e7bdbe238e127b68922971" => :mojave
    sha256 "39aef6117641eebb5157d30a6523b9881e9049d5f5cfabb9710f34f37387cb1a" => :high_sierra
    sha256 "e58185196573b1731c1ba57f9356798ab91fa35d9d0e89b23e03e0bfc9491dc3" => :sierra
    sha256 "7b86458254a98f67aceb32a8f2c3d0511c0fee3d2f1fb50df6017acc7c9b48dc" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "mysql-client"
  depends_on "openssl"
  depends_on "vim" unless OS.mac? # needed for xxd

  def install
    system "./autogen.sh"

    # Fix for luajit build breakage.
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "./configure", "--prefix=#{prefix}", "--with-mysql"
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end
