# Formula for the ug Godot version manager.
class Ug < Formula
  desc "Safe, scriptable Godot version manager"
  homepage "https://github.com/RafaelVidaurre/use-godot"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.2/use-godot-aarch64-apple-darwin.tar.xz"
      sha256 "e3917a7b5adad66ec3c83e68faaacf0919a2d07a6073245ce969298aefd16274"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.2/use-godot-x86_64-apple-darwin.tar.xz"
      sha256 "abaeddd0c66272a0861809ee7c7fa900dba5cdd79c3203bf24f52e3f1582af33"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.2/use-godot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ff60c87985a95a38091541151a3974c6551622c75a21930d07cf7273095d444"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RafaelVidaurre/use-godot/releases/download/v0.2.2/use-godot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42082aeeb0a844cdfc8e05b5b7dc64a0006a9c0b4e139bad0dbcc7c4f346da6f"
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
