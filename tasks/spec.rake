require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_opts = ['--color']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.rcov = true
  spec.rcov_opts = ['--exclude', '^spec,/gems/']
end

task :spec => [:check_dependencies, "spec:test_api"]
