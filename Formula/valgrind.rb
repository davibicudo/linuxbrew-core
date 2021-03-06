class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"
  revision 1 unless OS.mac?

  stable do
    url "https://sourceware.org/pub/valgrind/valgrind-3.14.0.tar.bz2"
    mirror "https://dl.bintray.com/homebrew/mirror/valgrind-3.14.0.tar.bz2"
    sha256 "037c11bfefd477cc6e9ebe8f193bb237fe397f7ce791b4a4ce3fa1c6a520baa5"

    depends_on :maximum_macos => :high_sierra if OS.mac?
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    sha256 "7869473ca1009d871dfcb496cc4d08e0318315d18721854ef42960b76e2ef64d" => :high_sierra
    sha256 "5ac984d472025c7bbc081e3be88b31f709944cf924945ebe85427f00d7cca73e" => :sierra
    sha256 "f572df0ef016c9292dfbd45b0b630b0f1f35589c48e77af5b397cc1a8181a283" => :x86_64_linux
  end

  head do
    url "https://sourceware.org/git/valgrind.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean "lib/valgrind"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-only64bit"
    args << "--build=amd64-darwin" if OS.mac?

    system "./autogen.sh" if build.head?

    # Look for headers in the SDK on Xcode-only systems: https://bugs.kde.org/show_bug.cgi?id=295084
    if OS.mac? && !MacOS::CLT.installed?
      inreplace "coregrind/Makefile.in", %r{(\s)(?=/usr/include/mach/)}, '\1'+MacOS.sdk_path.to_s
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage", shell_output("#{bin}/valgrind --help")
    # Fails without the package libc6-dbg or glibc-debuginfo installed.
    system "#{bin}/valgrind", "ls", "-l" if OS.mac?
  end
end
