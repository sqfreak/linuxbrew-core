class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.6.6",
      revision: "1f51ee137a2a4c8eb59a75194c0fb7244301c08a"
  license "Apache-2.0"

  bottle do
    sha256 "b7cb1217ac83ff79cd3033a24ada79b482a5932ed481f1897ec84af322ddfd93" => :catalina
    sha256 "7aaeb41a554ade95605d623e6ba76c9d91eab4432ae5716ae8cebc1907ac38f5" => :mojave
    sha256 "394ffcdf8d0206cc799fdd936490c4fc7195ad1784684690c76865fc3e47a102" => :high_sierra
    sha256 "030a24a6064aab74465a7949d7a2630f120cb294ee8918a4a2781afda82a42fb" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "make", "official-build", "OFFICIAL_BIN=#{bin}/fortio", "LIB_DIR=#{lib}"
    lib.install "ui/static", "ui/templates"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match /^All\sdone/, output.lines.last
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
