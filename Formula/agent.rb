class Agent < Formula
  include Language::Python::Virtualenv
  desc "Modern CLI control panel for autonomous AI agents"
  homepage "https://github.com/Millsondylan/Offline_ai_agents"
  url "https://github.com/Millsondylan/Offline_ai_agents/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "ecf019ae51e85d03265501c07067ffca7ce5ae6357e57d0360a140717877af51"
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
