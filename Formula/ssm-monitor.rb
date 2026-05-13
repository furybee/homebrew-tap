class SsmMonitor < Formula
  desc "TUI monitor for AWS SSM-managed instances with bookmarks, alarms, and SSM session launcher"
  homepage "https://github.com/furybee/ssm-monitor"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/ssm-monitor/releases/download/v0.2.0/ssm-monitor-aarch64-apple-darwin.tar.xz"
      sha256 "84b0fa2d37b94b8032c45b5a4a859e6cfbb1b47e493ba23d800f1d8efdeb7c5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/ssm-monitor/releases/download/v0.2.0/ssm-monitor-x86_64-apple-darwin.tar.xz"
      sha256 "2641492fd174d6028f24ca1b6c9aa44f1103c3477d5b930a77ac1260218e0e09"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/furybee/ssm-monitor/releases/download/v0.2.0/ssm-monitor-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "62f6e0474efc3da58f08c65d81310b20b6c1675857df82a0167e711a5c7cdce8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/furybee/ssm-monitor/releases/download/v0.2.0/ssm-monitor-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "705eca601a09dc95607a769bf64799875c6cd5cae9c1835d6a49cbadb3d1f893"
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
