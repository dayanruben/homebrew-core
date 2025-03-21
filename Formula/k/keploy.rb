class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v2.4.14.tar.gz"
  sha256 "9441cbb97fcd35d263aebfe018c032b97f9dc5c2236972a5bf693299d1b8ff55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e78eedbb63a24e88b6ea641c06a82e5b1e4b4edba0d4e7c7103d0533fe4fbec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e78eedbb63a24e88b6ea641c06a82e5b1e4b4edba0d4e7c7103d0533fe4fbec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e78eedbb63a24e88b6ea641c06a82e5b1e4b4edba0d4e7c7103d0533fe4fbec"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c1251d69c0b59d128e0eb88da8631b87a2b0fe8a20ffcf423506fda9369b4ce"
    sha256 cellar: :any_skip_relocation, ventura:       "5c1251d69c0b59d128e0eb88da8631b87a2b0fe8a20ffcf423506fda9369b4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7582393874af352b310ea615d166cc4ea12da694b4771812d2ef0afb3fc52579"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    system bin/"keploy", "config", "--generate", "--path", testpath
    assert_match "# Generated by Keploy", (testpath/"keploy.yml").read

    output = shell_output("#{bin}/keploy templatize --path #{testpath}")
    assert_match "No test sets found to templatize", output

    assert_match version.to_s, shell_output("#{bin}/keploy --version")
  end
end
