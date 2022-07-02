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
  s.files       = ['lib/asciidoctor-comment-links.rb']
  s.homepage    = 'https://www.diguage.com'
  s.metadata    = { "source_code_uri" => "https://github.com/diguage/asciidoctor-comment-links" }
  s.license     = 'MIT'

  s.require_paths = ['lib']
  # MAJOR.MINOR.PATCH
  # ~> 2     == ['>= 2',     '< 3']
  # ~> 2.2   == ['>= 2.2',   '< 3.0']
  # ~> 2.2.0 == ['>= 2.2.0', '< 2.3.0']
  s.add_development_dependency 'asciidoctor', '~> 2.0'
  s.add_development_dependency 'bundler', '~> 2.2'
  s.add_development_dependency 'minitest', '~> 5.16'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rouge', '~> 3.29'
  s.date = '2022-07-02'
  s.required_ruby_version = '>= 2.5'
end