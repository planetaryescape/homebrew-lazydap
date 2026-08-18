# The Homebrew formula for lazydap. `scripts/render_homebrew_formula.sh` in
# planetaryescape/lazydap fills in the version and the three checksums and the
# release workflow pushes the result to the planetaryescape/homebrew-lazydap
# tap. Edit the template in that repository, never the copy in the tap.
#
# This installs the release binary rather than building from source, so a
# `brew install` does not need a Rust toolchain and does not spend minutes
# compiling something CI has already compiled and checksummed.
class Lazydap < Formula
  desc "Scriptable, terminal-first debugger for C, C++, and Rust"
  homepage "https://github.com/planetaryescape/lazydap"
  # Stated rather than scanned out of the URL. `brew audit --strict` calls this
  # redundant, and it is, right up to the first prerelease: the URLs carry the
  # version twice and a tag like v0.2.0-rc1 is not something to let a filename
  # parser guess at.
  version "0.2.4"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/planetaryescape/lazydap/releases/download/v#{version}/lazydap-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "b9ae6ae33e61d39e0da27a71c4c35adc16e7d86ef8e5cafb3bfa56daea6ea6c3"
    end

    on_intel do
      url "https://github.com/planetaryescape/lazydap/releases/download/v#{version}/lazydap-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "70831a5152d165abc6b99f76734c0ceb8e502791a80835d8ab48f03571fbc175"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/planetaryescape/lazydap/releases/download/v#{version}/lazydap-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3f153a1913825fe424cadf167e3a87b8f674538ce5c94d8712947b003bb6a068"
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
      lazydap drives codelldb and does not bundle it. codelldb has to reach your PATH
      through a wrapper script, not a symlink: it finds liblldb by walking up from
      argv[0], so through a symlink that walk starts one directory too high and it
      dies in dlopen. The four commands are in the README:

        https://github.com/planetaryescape/lazydap#install

      Then check both halves are where lazydap expects:

        lazydap doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydap version")
  end
end
