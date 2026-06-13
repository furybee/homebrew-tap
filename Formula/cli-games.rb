class CliGames < Formula
  desc "A collection of terminal mini-games"
  homepage "https://github.com/furybee/cli-games"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.2/cli-games-aarch64-apple-darwin.tar.xz"
      sha256 "de960aa3e57651f7eab49425032f887d4790fd0c3a7dfc2d46b33167c78494c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.2/cli-games-x86_64-apple-darwin.tar.xz"
      sha256 "81e1b01561753e8343030cfea582356e41e4e6828777d7de19bc54f87386e37d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.2/cli-games-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "37272f7df940faa5edd838a69eea1934e2f8a04e2d64cf9ce51d87a483818db4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.2/cli-games-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c6ceb2d1b24fb2d37074ddf89bc220fd36de9c1a96cc3873be17e64e4d330cdc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cli-games" if OS.mac? && Hardware::CPU.arm?
    bin.install "cli-games" if OS.mac? && Hardware::CPU.intel?
    bin.install "cli-games" if OS.linux? && Hardware::CPU.arm?
    bin.install "cli-games" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
