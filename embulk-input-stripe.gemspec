# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'embulk-input-stripe'
  spec.version       = '0.1.0'
  spec.authors       = ['Daisuke Shimamoto']
  spec.summary       = 'Embulk input plugin for Stripe'
  spec.description   = 'Loads data from Stripe.'
  spec.email         = ['diskshima@gmail.com']
  spec.licenses      = ['MIT']
  spec.homepage      = 'https://github.com/diskshima/embulk-input-stripe'
  spec.files         = Dir.glob('lib/**/*.rb')

  spec.add_runtime_dependency 'stripe', ['>= 5.32.1']
  spec.add_development_dependency 'rake', ['>= 13.0.3']
end
