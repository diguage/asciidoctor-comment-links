begin
  require_relative 'lib/asciidoctor-comment-links/version'
rescue LoadError
  require 'asciidoctor-comment-links/version'
end

Gem::Specification.new do |s|
  s.name        = 'asciidoctor-comment-links'
  s.version     = AsciidoctorCommentLinks::VERSION
  s.summary     = "Turn the link in the comment of the source block into a clickable jump link."
  s.description = "It is an Asciidoctor Extension, it turns the link in the comment of the source block into a clickable jump link."
  s.authors     = ['diguage', 'Dan Allen']
  s.email       = ['leejun119@gmail.com', 'dan.j.allen@gmail.com']
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://www.diguage.com'
  s.metadata    = { "source_code_uri" => "https://github.com/diguage/asciidoctor-comment-links" }
  s.license     = 'MIT'

  s.require_paths = ['lib']
  # MAJOR.MINOR.PATCH
  # ~> 2     == ['>= 2',     '< 3']
  # ~> 2.2   == ['>= 2.2',   '< 3.0']
  # ~> 2.2.0 == ['>= 2.2.0', '< 2.3.0']
  s.add_runtime_dependency 'asciidoctor', ['>= 2.0.0', '< 3.0.0']
  s.add_runtime_dependency 'logger'
  s.add_runtime_dependency 'rouge', '>= 3.29'
  # CodeRay and Pygments are optional. Install the matching gem only if you use
  # those highlighters: `gem install coderay` or `gem install pygments.rb`.
  s.add_development_dependency 'ostruct'
  s.add_development_dependency 'rake', '~> 13.0.0'
  s.add_development_dependency 'rspec', '~> 3.13.0'
  s.date = '2022-07-02'
  s.required_ruby_version = '>= 2.3'
end
