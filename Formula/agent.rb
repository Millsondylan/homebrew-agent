class Agent < Formula
  include Language::Python::Virtualenv
  desc "Always-on offline-first coding agent with production gates and TUI"
  homepage "https://github.com/Millsondylan/Offline_ai_agents"
  url "https://github.com/Millsondylan/Offline_ai_agents/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "4b4c0cf96096f3cc28e5af447b0d07f94cc73298a1c0e3e9333556db6182c92b"
  license "Apache-2.0"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources using: "python@3.12"
  end

  def post_install
    # Install TUI dependencies
    system libexec/"bin/python", "-m", "pip", "install", "--quiet",
           "textual>=0.47.0",
           "watchdog>=3.0.0",
           "requests>=2.31.0",
           "keyring>=24.0.0"
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
