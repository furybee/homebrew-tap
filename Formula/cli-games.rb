class CliGames < Formula
  desc "A collection of terminal mini-games"
  homepage "https://github.com/furybee/cli-games"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.0/cli-games-aarch64-apple-darwin.tar.xz"
      sha256 "77e2d2abbfd3945bef3913d006376fc7741966fdcc96902cfc63012349e043e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.0/cli-games-x86_64-apple-darwin.tar.xz"
      sha256 "f86d4db6d85a9118ee419b288623fd244429532bacc1d04a828bc6996c7a7485"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.0/cli-games-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7597f43fcf7201d0898e418e0c237653faae875f6fa50e53d41a95ea37bcf572"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.0/cli-games-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9b168229ddb2a1882bb9a4fb1157e4b48ce0b7e98e180a756df6a1828364f276"
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
