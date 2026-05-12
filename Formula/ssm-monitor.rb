class SsmMonitor < Formula
  desc "TUI monitor for AWS SSM-managed instances"
  homepage "https://github.com/furybee/ssm-monitor"
  url "https://github.com/furybee/ssm-monitor/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6142cc38b98ed93bef6807a5be794c18e8db981d19bb163b905d5b4ff6e5c7c7"
  license "MIT"
  head "https://github.com/furybee/ssm-monitor.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssm-monitor --version")
  end
end
