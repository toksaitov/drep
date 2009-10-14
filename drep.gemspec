# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{drep}
  s.version = "0.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Toksaitov Dmitrii Alexandrovich"]
  s.date = %q{2009-10-30}
  s.default_executable = %q{drep}
  s.description = %q{DRep is a simple data collector and report generator. It can collect data through a specific
data provider and generate a report by populating a specified template with the picked up data.}
  s.email = ["drep.support@85.17.184.9"]
  s.executables = ["drep"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.txt", "\321opying.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "README.txt", "Rakefile", "assets/providers/drep_ml_provider.rb", "assets/rules/drep_wa_rules.rb", "assets/templates/drep_tda_template.erb", "bin/drep", "lib/drep.rb", "lib/drep/alterers/drep_extenders.rb", "lib/drep/alterers/drep_helpers.rb", "lib/drep/alterers/drep_validators.rb", "lib/drep/core/drep_binder.rb", "lib/drep/core/drep_environment.rb", "lib/drep/core/drep_executer.rb", "lib/drep/core/interfaces/drep_runnable.rb", "lib/drep/drep_cli.rb", "\321opying.txt"]
  s.post_install_message = %q{Thank you for installing the DRep system

Please be sure to read Readme.rdoc and History.rdoc
for useful information about this release.

For more information on DRep, see http:/85.17.184.9/drep}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{drep}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{DRep is a simple data collector and report generator}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.3.2"])
      s.add_development_dependency(%q<newgem>, [">= 1.5.1"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.3.2"])
      s.add_dependency(%q<newgem>, [">= 1.5.1"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.3.2"])
    s.add_dependency(%q<newgem>, [">= 1.5.1"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
