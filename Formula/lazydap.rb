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
  version "0.1.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/planetaryescape/lazydap/releases/download/v#{version}/lazydap-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "701bb76c5aae8b3a6006f9cd13e86649f68188eadf152b18b93df390ea834e0f"
    end

    on_intel do
      url "https://github.com/planetaryescape/lazydap/releases/download/v#{version}/lazydap-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "0d2a8cec675fc0d16b8a7b748476d7d00de97e9ff1a0e4e2161714e4ee133e0c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/planetaryescape/lazydap/releases/download/v#{version}/lazydap-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b600adfe27a5a872972a68422b20518f85a8040c7daf761d49be13ce04544dfb"
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
