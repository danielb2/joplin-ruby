lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'joplin/version'

Gem::Specification.new do |spec|
  spec.name          = 'joplin'
  spec.version       = Joplin::VERSION
  spec.authors       = ['Daniel Bretoi']
  spec.email         = ['daniel@bretoi.com']

  spec.summary       = 'joplin API'
  spec.description   = 'joplin API'
  spec.homepage      = 'http://github.com/danielb2/joplin-ruby'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'http://github.com/danielb2/joplin-ruby'
    spec.metadata['changelog_uri'] = 'http://github.com/danielb2/joplin-ruby'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }.reject { |f| f =~ /(console|setup)/ }
  spec.require_paths = ['lib']

  spec.add_dependency 'http', '~> 5.1.1'
  spec.add_dependency 'sqlite3', '~> 1.6.3'
  spec.add_dependency 'thor', '~> 1.2.2'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12.0'
end
