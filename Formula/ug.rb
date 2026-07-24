# Formula for the ug Godot version manager.
class Ug < Formula
  desc "Safe, scriptable Godot version manager"
  homepage "https://github.com/RafaelVidaurre/use-godot"
  version "0.2.1" if OS.linux?
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.1/use-godot-aarch64-apple-darwin.tar.xz"
      sha256 "d2f5e9550bbf104e863d21b79fae7894eb12ffd7e705d1380e211b389e640fb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.1/use-godot-x86_64-apple-darwin.tar.xz"
      sha256 "6b39c9b41cc853d5987b1d28e50cafb85db378825a1a907057ddb6064d307a8c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.1/use-godot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "950636c6b8be087c0b188f66d5da0efb6849d0d254b0e3e29dfcd7ab5008859a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.1/use-godot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3fc64744e7f65dcfc611e97f30508763753838b67a56ad788f31df52c12cf876"
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
