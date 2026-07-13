# Formula for the ug Godot version manager.
class Ug < Formula
  desc "Safe, scriptable Godot version manager"
  homepage "https://github.com/RafaelVidaurre/use-godot"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.0/use-godot-aarch64-apple-darwin.tar.xz"
      sha256 "13ce0f71a52bb263b1797ecd2be437b86befedf9e3abf8c17bba71d893a87f46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.0/use-godot-x86_64-apple-darwin.tar.xz"
      sha256 "6835adad9ae25ca69e2f4bea9abdd7e18b9b5f9c1a81f35486c01adf2930bcc0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.0/use-godot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dbf81d372952dcde35fb61c107f44c6a0bf0d35deae09651ee229f62d3777b0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.0/use-godot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "336a961a4552ddfa86447a1caf0cf578caa99e6008b4cde2d5fa4a048ff86f1c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ug" if OS.mac? && Hardware::CPU.arm?
    bin.install "ug" if OS.mac? && Hardware::CPU.intel?
    bin.install "ug" if OS.linux? && Hardware::CPU.arm?
    bin.install "ug" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match "ug #{version}", shell_output("#{bin}/ug --version")
  end
end
