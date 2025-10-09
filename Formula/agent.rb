class Agent < Formula
  include Language::Python::Virtualenv
  desc "Autonomous AI coding agent with LLM integration, comprehensive verification, and dashboard"
  homepage "https://github.com/Millsondylan/Offline_ai_agents"
  url "https://github.com/Millsondylan/Offline_ai_agents/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "e2bce68397c6f80bd6dd9c5367c0cdf2d1f5027cb60cbdf197cb76bdf0a537d7"
  license "Apache-2.0"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources using: "python@3.12"
  end

  def post_install
    # Install required analysis and development tools for full agent functionality
    system libexec/"bin/python", "-m", "pip", "install", "--quiet",
           "ruff>=0.1.0",           # Python linter and formatter
           "pytest>=7.0.0",         # Test framework
           "bandit>=1.7.0",         # Security scanner
           "semgrep>=1.0.0",        # Security and code quality scanner
           "mypy>=1.0.0",           # Type checker
           "pip-audit>=2.0.0",      # Dependency vulnerability scanner
           "coverage>=7.0.0"        # Code coverage analysis

    # Ensure the tools are accessible in PATH
    bin_path = libexec/"bin"
    ohai "Python analysis tools installed to #{bin_path}"
    ohai "Agent is now fully configured with all required tools"
  end

  service do
    run [opt_bin/"agent", "--headless", "--cooldown-seconds=0"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/agent.log"
    error_log_path var/"log/agent.err.log"
  end

  test do
    # Test basic functionality
    system "#{bin}/agent", "--version"

    # Test that required tools are available in the virtual environment
    assert_match "ruff", shell_output("#{libexec}/bin/pip list")
    assert_match "pytest", shell_output("#{libexec}/bin/pip list")
    assert_match "bandit", shell_output("#{libexec}/bin/pip list")

    # Test dashboard imports work
    system libexec/"bin/python", "-c", "import agent_dashboard; print('✓ Dashboard imports successfully')"

    # Test core agent functionality
    system libexec/"bin/python", "-c", "from agent.run import AgentLoop; print('✓ Core agent imports successfully')"
  end
end
