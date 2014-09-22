Gem::Specification.new do |s|
  s.name        = 'redcap-survey-api'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.homepage    = "https://github.com/mmcrockett/redcap-survey-api"
  s.date        = '2014-09-02'
  s.summary     = %q{REDCap Survey API - Welcome to easy interaction with REDCap through Ruby.}
  s.description = %q{REDCap Survey API provides a ruby-style interface for interacting with the REDCap survey system from Vanderbilt.}
  s.authors     = ["Mike Crockett"]
  s.email       = "redcap@mmcrockett.com"
  s.license     = "MIT"

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths    = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.add_development_dependency "rake"
  s.add_development_dependency "csv"
  s.add_development_dependency "nokogiri"
  s.add_dependency "mechanize"
  s.add_dependency "json"
end
