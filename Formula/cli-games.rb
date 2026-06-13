class CliGames < Formula
  desc "A collection of terminal mini-games"
  homepage "https://github.com/furybee/cli-games"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/cli-games/releases/download/v0.1.0/cli-games-aarch64-apple-darwin.tar.xz"
      sha256 "edd69dfc708e0656e999204b0fe74e7e7378963ccc1d2333b64d4775f4abbbb0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/cli-games/releases/download/v0.1.0/cli-games-x86_64-apple-darwin.tar.xz"
      sha256 "41fad29187547201f1e753ff0228584baa21d0b00d93547b87c06b1fac66a067"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/cli-games/releases/download/v0.1.0/cli-games-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "45048f501a70a1a565519fbaed8b44ea0be8c6feefca29b9a17605d9d21de9b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/cli-games/releases/download/v0.1.0/cli-games-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "685a32bbe9f510ac304dc73b63a9eb0ea28ff53fe6d2519b9d8c2fac0dfa91e7"
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
