class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.7/composer.phar"
  sha256 "2528507840901565fe6cecd19c7e9f8983b8d91b5eb4bab1599b14254401e675"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48854a0d71e808c6ae98f4602bdaef4b0ce0e9deaf11f5b431b092c07265f98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48854a0d71e808c6ae98f4602bdaef4b0ce0e9deaf11f5b431b092c07265f98e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48854a0d71e808c6ae98f4602bdaef4b0ce0e9deaf11f5b431b092c07265f98e"
    sha256 cellar: :any_skip_relocation, sonoma:        "47a8358556cfd67c624595a50c562d6595d332ea79146551d7298c4099ba57ae"
    sha256 cellar: :any_skip_relocation, ventura:       "47a8358556cfd67c624595a50c562d6595d332ea79146551d7298c4099ba57ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c4df30d670cf0c23e5b7d42041c29fbb4c7eb069a986a447be69564c23af29c"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "composer.phar" => "composer"
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "name": "homebrew/test",
        "authors": [
          {
            "name": "Homebrew"
          }
        ],
        "require": {
          "php": ">=5.3.4"
          },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        }
      }
    JSON

    (testpath/"src/HelloWorld/Greetings.php").write <<~PHP
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    PHP

    (testpath/"tests/test.php").write <<~PHP
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    PHP

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
