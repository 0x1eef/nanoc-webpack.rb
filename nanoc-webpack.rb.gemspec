# frozen_string_literal: true

require "./lib/nanoc/webpack/version"
Gem::Specification.new do |gem|
  gem.name = "nanoc-webpack.rb"
  gem.authors = ["0x1eef"]
  gem.email = ["0x1eef@protonmail.com"]
  gem.homepage = "https://github.com/0x1eef/nanoc-webpack.rb#readme"
  gem.version = Nanoc::Webpack::VERSION
  gem.licenses = ["0BSD"]
  gem.files = `git ls-files`.split($/)
  gem.require_paths = ["lib"]
  gem.summary = "nanoc-webpack.rb = nanoc + webpack"
  gem.description = gem.summary
  gem.add_runtime_dependency "ryo.rb", "~> 0.5"
  gem.add_runtime_dependency "test-cmd.rb", "~> 0.12.3"
  gem.add_development_dependency "yard", "~> 0.9"
  gem.add_development_dependency "redcarpet", "~> 3.5"
  gem.add_development_dependency "rspec", "~> 3.10"
  gem.add_development_dependency "standard", "~> 1.13"
  gem.add_development_dependency "rubocop-rspec", "~> 2.11"
end
