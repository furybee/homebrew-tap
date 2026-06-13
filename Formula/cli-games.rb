class CliGames < Formula
  desc "A collection of terminal mini-games"
  homepage "https://github.com/furybee/cli-games"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.1/cli-games-aarch64-apple-darwin.tar.xz"
      sha256 "db41587f4ac546df54d29b99590d86beee86678c75b909f08000ee396fa0970b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.1/cli-games-x86_64-apple-darwin.tar.xz"
      sha256 "1101e73b029574d57907084f6f1cc7c49b757cf5873f8b4bb1f283726972f33e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.1/cli-games-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f48a2ebe9927f4a3d505fde3a453254c6a4ade9b37a024107f84ec49461fef1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/cli-games/releases/download/v0.2.1/cli-games-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e060a4d5f320192f306954f0c7524b44065619913210096745b812aeffb284b7"
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
