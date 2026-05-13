class SsmMonitor < Formula
  desc "TUI monitor for AWS SSM-managed instances with bookmarks, alarms, and SSM session launcher"
  homepage "https://github.com/furybee/ssm-monitor"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/ssm-monitor/releases/download/v0.1.2/ssm-monitor-aarch64-apple-darwin.tar.xz"
      sha256 "d40ca49297fa2434ba6f6cb079a1f5743e485291db24b373e4b5376b02b375a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/ssm-monitor/releases/download/v0.1.2/ssm-monitor-x86_64-apple-darwin.tar.xz"
      sha256 "cf53502f7cd138243695ba2c7a70215a0ae62a3026cb91313b3ab584309ae0ed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/ssm-monitor/releases/download/v0.1.2/ssm-monitor-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "37758f153d1ae503f4f256d2d57add57967cbd8a613e1af53323e8964584568a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/ssm-monitor/releases/download/v0.1.2/ssm-monitor-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb5e9ece85621e7b273d652cb1feb8b970a2f3fb839dc0db5e171f935acca2c5"
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
    bin.install "ssm-monitor" if OS.mac? && Hardware::CPU.arm?
    bin.install "ssm-monitor" if OS.mac? && Hardware::CPU.intel?
    bin.install "ssm-monitor" if OS.linux? && Hardware::CPU.arm?
    bin.install "ssm-monitor" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
