# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{datacatalog}
  s.version = "0.4.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luigi Montanez", "David James"]
  s.date = %q{2010-03-12}
  s.description = %q{A Ruby client library for the National Data Catalog API}
  s.email = %q{luigi@sunlightfoundation.com}
  s.extra_rdoc_files = [
    "LICENSE.md",
     "README.md"
  ]
  s.files = [
    ".gitignore",
     "LICENSE.md",
     "README.md",
     "Rakefile",
     "datacatalog.gemspec",
     "lib/base.rb",
     "lib/connection.rb",
     "lib/cursor.rb",
     "lib/datacatalog.rb",
     "lib/main.rb",
     "lib/resources/about.rb",
     "lib/resources/api_key.rb",
     "lib/resources/comment.rb",
     "lib/resources/document.rb",
     "lib/resources/download.rb",
     "lib/resources/favorite.rb",
     "lib/resources/note.rb",
     "lib/resources/organization.rb",
     "lib/resources/rating.rb",
     "lib/resources/report.rb",
     "lib/resources/source.rb",
     "lib/resources/user.rb",
     "sandbox_api.yml.example",
     "spec/about_spec.rb",
     "spec/api_key_spec.rb",
     "spec/base_spec.rb",
     "spec/comment_spec.rb",
     "spec/datacatalog_spec.rb",
     "spec/document_spec.rb",
     "spec/download_spec.rb",
     "spec/favorite_spec.rb",
     "spec/note_spec.rb",
     "spec/organization_spec.rb",
     "spec/rating_spec.rb",
     "spec/report_spec.rb",
     "spec/setup_api.rb",
     "spec/source_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/user_spec.rb",
     "tasks/rdoc.rake",
     "tasks/spec.rake",
     "tasks/test_api.rake"
  ]
  s.homepage = %q{http://github.com/sunlightlabs/datacatalog}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{datacatalog}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Client for the National Data Catalog API}
  s.test_files = [
    "spec/about_spec.rb",
     "spec/api_key_spec.rb",
     "spec/base_spec.rb",
     "spec/comment_spec.rb",
     "spec/datacatalog_spec.rb",
     "spec/document_spec.rb",
     "spec/download_spec.rb",
     "spec/favorite_spec.rb",
     "spec/note_spec.rb",
     "spec/organization_spec.rb",
     "spec/rating_spec.rb",
     "spec/report_spec.rb",
     "spec/setup_api.rb",
     "spec/source_spec.rb",
     "spec/spec_helper.rb",
     "spec/user_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.5"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.5.2"])
      s.add_runtime_dependency(%q<mash>, [">= 0.0.3"])
      s.add_runtime_dependency(%q<version_string>, [">= 0.1.0"])
      s.add_development_dependency(%q<jeweler>, [">= 1.2.1"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.8"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.3.5"])
      s.add_dependency(%q<httparty>, [">= 0.5.2"])
      s.add_dependency(%q<mash>, [">= 0.0.3"])
      s.add_dependency(%q<version_string>, [">= 0.1.0"])
      s.add_dependency(%q<jeweler>, [">= 1.2.1"])
      s.add_dependency(%q<rspec>, [">= 1.2.8"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.3.5"])
    s.add_dependency(%q<httparty>, [">= 0.5.2"])
    s.add_dependency(%q<mash>, [">= 0.0.3"])
    s.add_dependency(%q<version_string>, [">= 0.1.0"])
    s.add_dependency(%q<jeweler>, [">= 1.2.1"])
    s.add_dependency(%q<rspec>, [">= 1.2.8"])
  end
end

