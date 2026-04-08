class CscsKey < Formula
  desc "CLI tool to manage SSH keys for the Swiss National Supercomputing Centre (CSCS)"
  homepage "https://github.com/eth-cscs/cscs-key"
  version "1.0.0"
  url "https://github.com/eth-cscs/cscs-key/archive/refs/tags/#{version}.tar.gz"
  sha256 "d31d72e6355b0e98fc2a6376b188e6ae91d0988c0d292e6d9a13fe8c324d6391"

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "pkgconf" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    output = shell_output("#{bin}/cscs-key --help")
    assert_match "Usage: cscs-key", output
    assert_match "sign", output
  end
end
