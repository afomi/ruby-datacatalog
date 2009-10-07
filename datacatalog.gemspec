# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{datacatalog}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luigi Montanez", "David James"]
  s.date = %q{2009-10-07}
  s.description = %q{Ruby library that wraps the National Data Catalog API}
  s.email = %q{luigi@sunlightfoundation.com}
  s.extra_rdoc_files = [
    "LICENSE.md",
     "README.md"
  ]
  s.files = [
    ".gitignore",
     "CHANGES.md",
     "LICENSE.md",
     "README.md",
     "Rakefile",
     "VERSION",
     "datacatalog.gemspec",
     "lib/base.rb",
     "lib/datacatalog.rb",
     "lib/require_helpers.rb",
     "lib/resources/api_key.rb",
     "lib/resources/source.rb",
     "lib/resources/user.rb",
     "sandbox_api.yml.example",
     "spec/api_key_spec.rb",
     "spec/base_spec.rb",
     "spec/source_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/user_spec.rb"
  ]
  s.homepage = %q{http://github.com/sunlightlabs/datacatalog}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{datacatalog}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Wrapper for the National Data Catalog API}
  s.test_files = [
    "spec/api_key_spec.rb",
     "spec/base_spec.rb",
     "spec/source_spec.rb",
     "spec/spec_helper.rb",
     "spec/user_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.4"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.4.5"])
      s.add_runtime_dependency(%q<mash>, [">= 0.0.3"])
      s.add_development_dependency(%q<jeweler>, [">= 1.2.1"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.8"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.3.4"])
      s.add_dependency(%q<httparty>, [">= 0.4.5"])
      s.add_dependency(%q<mash>, [">= 0.0.3"])
      s.add_dependency(%q<jeweler>, [">= 1.2.1"])
      s.add_dependency(%q<rspec>, [">= 1.2.8"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.3.4"])
    s.add_dependency(%q<httparty>, [">= 0.4.5"])
    s.add_dependency(%q<mash>, [">= 0.0.3"])
    s.add_dependency(%q<jeweler>, [">= 1.2.1"])
    s.add_dependency(%q<rspec>, [">= 1.2.8"])
  end
end
