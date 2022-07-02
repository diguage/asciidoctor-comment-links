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
  s.authors     = ['diguage']
  s.email       = 'leejun119@gmail.com'
  s.files       = ['lib/asciidoctor-comment-links.rb']
  s.homepage    = 'https://www.diguage.com'
  s.metadata    = { "source_code_uri" => "https://github.com/diguage/asciidoctor-comment-links" }
  s.license     = 'MIT'

  s.require_paths = ['lib']
  s.add_development_dependency 'asciidoctor', '~> 2.0.0'
end