# -*- encoding: utf-8 -*-
require File.expand_path('../lib/simple_recaptcha/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Wojciech Wnętrzak"]
  gem.email         = ["w.wnetrzak@gmail.com"]
  gem.description   = %q{Simple Google reCAPTCHA library}
  gem.summary       = %q{Google reCAPTCHA library}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "simple_recaptcha"
  gem.require_paths = ['lib']
  gem.version       = SimpleRecaptcha::VERSION

  gem.add_development_dependency "mocha"
end
