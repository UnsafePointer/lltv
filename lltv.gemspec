# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lltv/version'

Gem::Specification.new do |spec|
  spec.name          = "lltv"
  spec.version       = LLTV::VERSION
  spec.authors       = ["Renzo Crisóstomo"]
  spec.email         = ["renzo.crisostomo@me.com"]
  spec.summary       = %q{Love Live! Twitter bot inspired in @keion_tv}
  spec.homepage      = "https://github.com/Ruenzuo/lltv"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = 'lltv'
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency 'claide', '~> 1.0.0'
end
