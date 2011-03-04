# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "feed_reedr/version"

Gem::Specification.new do |s|
  s.name        = "feed_reedr"
  s.version     = FeedReedr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tim Glen"]
  s.email       = ["tim@tag.ca"]
  s.homepage    = ""
  s.summary     = %q{CSV fetcher, reader and feeder}
  s.description = %q{Fetches a list of csv files (and attachment files) and, with a bit of configuration, feeds them into your models}

  s.add_development_dependency "rspec"

  s.rubyforge_project = "feed_reedr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
