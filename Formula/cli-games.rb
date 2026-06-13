class CliGames < Formula
  desc "A collection of terminal mini-games"
  homepage "https://github.com/furybee/cli-games"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/cli-games/releases/download/v0.1.1/cli-games-aarch64-apple-darwin.tar.xz"
      sha256 "67fe6c132f8b8228de56bd576d61a4559b7e1454a8b27f29b384710dd665f5fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/cli-games/releases/download/v0.1.1/cli-games-x86_64-apple-darwin.tar.xz"
      sha256 "5502d10a9f0bdf8ca3566e9859f8ab1bb8220672ad277a95d58b450e62e78d9c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/cli-games/releases/download/v0.1.1/cli-games-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1bbfb8bd90b15170da5ef66b1e823ab02824f8352604c375e2e02bc39637d672"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/cli-games/releases/download/v0.1.1/cli-games-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9858ad83f47901082c129f1bc4605ca6897de41a6b1abbc1e93b355026d6c06c"
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
