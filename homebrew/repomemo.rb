class Repomemo < Formula
  desc "CLI that initializes shared AI project memory in any repository"
  homepage "https://github.com/SUN-1024/repomemo"
  url "https://github.com/SUN-1024/repomemo/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "254429bc4b1e20d3123ecc1008a002f29c21c4d317cc136437a4cfcfe3d18baf"
  license "MIT"
  version "1.0.0"

  # Bash 3.2+ is sufficient; macOS ships with /bin/bash 3.2 already.
  uses_from_macos "bash"

  def install
    bin.install "bin/repomemo"
    (share/"repomemo").install "templates"

    # Rewrite the template path so the installed script finds templates in
    # Homebrew's share directory rather than the source-tree sibling.
    inreplace bin/"repomemo",
              'TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")/templates"',
              "TEMPLATE_DIR=\"#{share}/repomemo/templates\""
  end

  test do
    assert_match "repomemo #{version}", shell_output("#{bin}/repomemo --version")
    assert_match "USAGE", shell_output("#{bin}/repomemo --help")

    # init must create the full scaffold in a fresh directory
    mkdir testpath/"target"
    system bin/"repomemo", "init", "--target", testpath/"target"
    %w[
      .ai/README.md
      .ai/project.md
      .ai/architecture.md
      .ai/definition-of-done.md
      .ai/review-checklist.md
      .ai/memory.md
      .ai/handoff.md
      CLAUDE.md
      AGENTS.md
    ].each do |rel|
      assert_predicate testpath/"target"/rel, :exist?, "missing after init: #{rel}"
    end

    # check must pass on the directory we just initialized
    system bin/"repomemo", "check", testpath/"target"
  end
end
