# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "tryouts"
  s.version = "2.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Delano Mandelbaum"]
  s.date = "2012-04-30"
  s.description = "Don't waste your time writing tests"
  s.email = "delano@solutious.com"
  s.executables = ["try"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "CHANGES.txt",
     "LICENSE.txt",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "bin/try",
     "lib/tryouts.rb",
     "try/step1_try.rb",
     "try/step2_try.rb",
     "try/step3_try.rb",
     "try/step4_try.rb",
     "tryouts.gemspec"
  ]
  s.homepage = "http://github.com/delano/tryouts"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "tryouts"
  s.rubygems_version = "1.8.22"
  s.summary = "Don't waste your time writing tests"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sysinfo>, [">= 0.7.3"])
    else
      s.add_dependency(%q<sysinfo>, [">= 0.7.3"])
    end
  else
    s.add_dependency(%q<sysinfo>, [">= 0.7.3"])
  end
end

