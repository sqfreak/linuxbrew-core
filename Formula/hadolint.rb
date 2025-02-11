class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.18.0.tar.gz"
  sha256 "0ebe67e543226721c3802dd56db0355575accf50f10c09fe188bbb604aa8c193"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ae5b6cfc174f50b883fd7907774d5d43250a18a2774b3f80d806122ed8da9c5a" => :catalina
    sha256 "ce882dfa51e5ca6025362a499ff280af2c676fad485ca5157ad4c9ceca8934e0" => :mojave
    sha256 "9c8ea84c521ab94e4f78d73b67593738760cb437e6e050e0e6f81be62c944440" => :high_sierra
    sha256 "5a1ce5e6645c8f7dc72cff2d4239bd61fdc675150d7b1991d73189cc859c3aab" => :x86_64_linux
  end

  depends_on "haskell-stack" => :build

  uses_from_macos "xz"

  on_linux do
    depends_on "gmp"
  end

  def install
    unless OS.mac?
      gmp = Formula["gmp"]
      ENV.prepend_path "LD_LIBRARY_PATH", gmp.lib
      ENV.prepend_path "LIBRARY_PATH", gmp.lib
    end

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "-j#{jobs}", "build"
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
