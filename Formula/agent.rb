class Agent < Formula
  include Language::Python::Virtualenv
  desc "Fully autonomous AI coding agent with real execution"
  homepage "https://github.com/Millsondylan/Offline_ai_agents"
  url "https://github.com/Millsondylan/Offline_ai_agents/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f4c08203d3bc40f73a6c2c8c6472734beaede98b625436c4e745e9fea93f753d"
  license "Apache-2.0"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources using: "python@3.12"
  end

  def post_install
    # No additional dependencies needed - uses Python curses (built-in)
  end

  service do
    run [opt_bin/"agent", "--headless", "--cooldown-seconds=0"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/agent.log"
    error_log_path var/"log/agent.err.log"
  end

  test do
    system "#{bin}/agent", "--version"
    system "#{bin}/agent", "run", "--max-cycles=1"
  end
end
