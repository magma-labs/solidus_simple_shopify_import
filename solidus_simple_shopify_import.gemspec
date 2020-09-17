# frozen_string_literal: true

require_relative 'lib/solidus_simple_shopify_import/version'

Gem::Specification.new do |spec|
  spec.name = 'solidus_simple_shopify_import'
  spec.version = SolidusSimpleShopifyImport::VERSION
  spec.authors = ['Edwin Cruz']
  spec.email = 'edwin.cruz@magmalabs.io'

  spec.summary = 'Simple products importer for solidus'
  spec.description = 'Import products from Shopify using public URL'
  spec.homepage = 'https://github.com/softr8/solidus_simple_shopify_import'
  spec.license = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/softr8/solidus_simple_shopify_import'
  spec.metadata['changelog_uri'] = 'https://github.com/softr8/solidus_simple_shopify_import/releases'

  spec.required_ruby_version = Gem::Requirement.new('~> 2.4')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty', '>= 0.18.0'
  spec.add_dependency 'solidus_core', ['>= 2.0.0', '< 3']
  spec.add_dependency 'solidus_support', '~> 0.5'

  spec.add_development_dependency 'solidus_dev_support'
end
