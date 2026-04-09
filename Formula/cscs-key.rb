class CscsKey < Formula
  desc "CLI tool to manage SSH keys for the Swiss National Supercomputing Centre (CSCS)"
  homepage "https://github.com/eth-cscs/cscs-key/blob/master/README.md"
  url "https://github.com/eth-cscs/cscs-key/archive/refs/tags/1.0.0.tar.gz"
  sha256 "d31d72e6355b0e98fc2a6376b188e6ae91d0988c0d292e6d9a13fe8c324d6391"
  head "https://github.com/eth-cscs/cscs-key.git", branch: "master"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  def caveats
    shell = Utils::Shell.preferred || Utils::Shell.parent
    profile = Utils::Shell.profile

    command = case shell
    when :bash, :zsh
      "echo 'source <(cscs-key completion #{shell})' >> #{profile}"
    when :fish
      "echo 'cscs-key completion fish | source' >> #{profile}"
    when :pwsh
      "Add-Content -Path #{profile} -Value 'cscs-key completion powershell | Out-String | Invoke-Expression'"
    end

    if command
      <<~EOS
        To enable shell completion for your current shell, run:
          #{command}
      EOS
    else
      <<~EOS
        Shell completion is available via:
          cscs-key completion <shell>

        Supported shells: bash, zsh, fish, powershell, elvish.
      EOS
    end
  end

  test do
    output = shell_output("#{bin}/cscs-key --help")
    assert_match "Usage: cscs-key", output
    assert_match "sign", output
  end
end
