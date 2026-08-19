# The Homebrew formula for lazydap. `scripts/render_homebrew_formula.sh` in
# planetaryescape/lazydap fills in the version and the three checksums and the
# release workflow pushes the result to the planetaryescape/homebrew-lazydap
# tap. Edit the template in that repository, never the copy in the tap.
#
# This installs the release binary rather than building from source, so a
# `brew install` does not need a Rust toolchain and does not spend minutes
# compiling something CI has already compiled and checksummed.
class Lazydap < Formula
  desc "Scriptable, terminal-first debugger for C, C++, Rust, Python, and Go"
  homepage "https://github.com/planetaryescape/lazydap"
  # Stated rather than scanned out of the URL. `brew audit --strict` calls this
  # redundant, and it is, right up to the first prerelease: the URLs carry the
  # version twice and a tag like v0.2.0-rc1 is not something to let a filename
  # parser guess at.
  version "0.2.9"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/planetaryescape/lazydap/releases/download/v#{version}/lazydap-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "fd9d68c15dc5e87a0d0ec0ef13a1513167f349009e9621e17a934a7f5ab055be"
    end

    on_intel do
      url "https://github.com/planetaryescape/lazydap/releases/download/v#{version}/lazydap-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "fc7678e63dee20a3cf1938d6bf72062a97858fb824c66ef463c13e4e81285d9c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/planetaryescape/lazydap/releases/download/v#{version}/lazydap-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "30902842f9455bab2f36ea5a82ad4d99bd3e5819d40ab1c4150c1bbe2dfbfca5"
    end
  end

  def install
    bin.install "lazydap"
    # Homebrew copies README.md and CHANGELOG.md out of the tarball on its own.
    # It does not recognise these two, and a dual-licensed binary should ship
    # both licence texts.
    prefix.install "LICENSE-MIT"
    prefix.install "LICENSE-APACHE"
  end

  def caveats
    <<~EOS
      lazydap drives debug adapters and bundles none of them. Install the one for
      the language you are debugging:

        C, C++, Rust   codelldb   https://github.com/vadimcn/codelldb/releases
        Python         debugpy    python3 -m pip install debugpy
        Go             delve      go install github.com/go-delve/delve/cmd/dlv@latest

      codelldb has to reach your PATH through a wrapper script, not a symlink: it
      finds liblldb by walking up from argv[0], so through a symlink that walk starts
      one directory too high and it dies in dlopen. The four commands are in the
      README:

        https://github.com/planetaryescape/lazydap#install

      Then check what you have. One usable adapter is enough for it to pass:

        lazydap doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydap version")
  end
end
