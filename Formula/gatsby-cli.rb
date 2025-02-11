require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.70.tgz"
  sha256 "b260b9805377f697ec5b2bd9f6cd9ad810a5b4ea925f7a9d5816585dc3d7f1b4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5097a3fa7af9e10a7be0b755d0d7ddf7ea96eeba208f1b053f4e2b1f450c17a2" => :catalina
    sha256 "44f6aaa837bdff5fa7d6f1624998356d2f814f8a4040c079c8cfe2e73e2d5712" => :mojave
    sha256 "5d74b6cbb529b6245eb17b2a53d79b5ca764d4d2aa2ed83af2cb93fe3ea824c3" => :high_sierra
  end

  depends_on "node"

  on_linux do
    depends_on "linuxbrew/xorg/xorg"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    return if Process.uid.zero?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
