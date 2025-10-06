class Agent < Formula
  include Language::Python::Virtualenv
  desc "Fully autonomous AI coding agent with real execution"
  homepage "https://github.com/Millsondylan/Offline_ai_agents"
  url "https://github.com/Millsondylan/Offline_ai_agents/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "7db9e4aa19d72be7404dacd6e3709dee5bda1aba5c6277fb1ad0af59dffd89b5"
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
