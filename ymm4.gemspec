# frozen_string_literal: true

require_relative "lib/ymm4/version"

Gem::Specification.new do |spec|
  spec.name = "ymm4"
  spec.version = YMM4::VERSION
  spec.authors = ["KozMozEnjel"]
  spec.email = ["kozmozenjel@outlook.com"]

  spec.summary = "A solution for reset FPS and Resolution of YMM4 project"
  spec.description = "A YukkuriMovieMaker Utils. ゆっくりムービーメーカー4. Yukkuri Movie Maker"
  spec.homepage = "https://www.github.com/saisui"
  spec.license = "GPL-3"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://github.com/saisui/ymm4rb"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/saisui/ymm4rb"
  spec.metadata["changelog_uri"] = "https://github.com/saisui/ymm4rb/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
